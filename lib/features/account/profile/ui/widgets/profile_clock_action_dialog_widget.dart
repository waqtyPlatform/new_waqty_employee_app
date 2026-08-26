import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/attendance_session_model.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/services/profile_service.dart';
import 'package:new_waqty_employee_app/features/account/profile/logic/profile_cubit.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_clock_success_dialog_widget.dart';

class ProfileClockActionDialogWidget extends StatefulWidget {
  final bool isClockedIn;
  final bool isOnBreak;
  final ProfileCubit cubit;

  const ProfileClockActionDialogWidget({
    super.key,
    required this.isClockedIn,
    required this.cubit,
    this.isOnBreak = false,
  });

  static Future<void> show(
    BuildContext context, {
    required bool isClockedIn,
    required ProfileCubit cubit,
    bool isOnBreak = false,
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: AppColors.greyColor3004.withValues(alpha: .4),
      pageBuilder: (_, _, _) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: Center(
            child: ProfileClockActionDialogWidget(
              isClockedIn: isClockedIn,
              cubit: cubit,
              isOnBreak: isOnBreak,
            ),
          ),
        );
      },
    );
  }

  @override
  State<ProfileClockActionDialogWidget> createState() =>
      _ProfileClockActionDialogWidgetState();
}

class _ProfileClockActionDialogWidgetState
    extends State<ProfileClockActionDialogWidget> {
  ProfileAttendanceAction? _loadingAction;
  Position? _currentPositionValue;
  bool _isCheckingBranchRange = true;
  bool? _isWithinBranchRange;

  @override
  void initState() {
    super.initState();
    _loadBranchRangeStatus();
  }

  @override
  Widget build(BuildContext context) {
    final actionKey = widget.isClockedIn
        ? 'profile.clockOut'
        : 'profile.clockIn';
    final actionColor = widget.isClockedIn
        ? AppColors.errorColor100
        : AppColors.greenColor500;
    final now = DateTime.now();

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300.w,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.greyColorFA, width: .8.w),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: .1),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: .06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ClockDialogHeaderWidget(title: context.tr(actionKey)),
            verticalSpace(12),
            Text(
              AppDateFormat.timeWithSeconds(context, now),
              textAlign: TextAlign.center,
              style: TextStyles.font24greyColor900Weight600,
            ),
            verticalSpace(4),
            Text(
              AppDateFormat.dayMonth(context, now),
              textAlign: TextAlign.center,
              style: TextStyles.font14greyColorA3W400,
            ),
            verticalSpace(16),
            _ClockBranchInfoWidget(cubit: widget.cubit),
            verticalSpace(12),
            _BranchRangeWidget(
              isChecking: _isCheckingBranchRange,
              isWithinRange: _isWithinBranchRange,
            ),
            if (widget.isClockedIn) ...[
              verticalSpace(12),
              _ClockDurationWidget(
                isOnBreak: widget.isOnBreak,
                session: widget.cubit.currentAttendanceSession,
              ),
            ],
            if (!widget.isOnBreak) ...[
              verticalSpace(12),
              _ClockActionButtonWidget(
                title: context.tr(actionKey),
                color: actionColor,
                isLoading: _isActionLoading(
                  widget.isClockedIn
                      ? ProfileAttendanceAction.clockOut
                      : ProfileAttendanceAction.clockIn,
                ),
                isDisabled: _loadingAction != null,
                onTap: () => _runAction(
                  context,
                  widget.isClockedIn
                      ? ProfileAttendanceAction.clockOut
                      : ProfileAttendanceAction.clockIn,
                  widget.isClockedIn
                      ? ProfileClockSuccessType.clockedOut
                      : ProfileClockSuccessType.clockedIn,
                ),
              ),
            ],
            if (widget.isClockedIn) ...[
              verticalSpace(widget.isOnBreak ? 12 : 12),
              _ClockBreakButtonWidget(
                isOnBreak: widget.isOnBreak,
                isLoading: _isActionLoading(
                  widget.isOnBreak
                      ? ProfileAttendanceAction.endBreak
                      : ProfileAttendanceAction.startBreak,
                ),
                isDisabled: _loadingAction != null,
                onTap: () => _runAction(
                  context,
                  widget.isOnBreak
                      ? ProfileAttendanceAction.endBreak
                      : ProfileAttendanceAction.startBreak,
                  widget.isOnBreak
                      ? ProfileClockSuccessType.breakEnded
                      : ProfileClockSuccessType.breakStarted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _runAction(
    BuildContext context,
    ProfileAttendanceAction action,
    ProfileClockSuccessType successType,
  ) async {
    if (_loadingAction != null) return;
    setState(() => _loadingAction = action);

    final navigator = Navigator.of(context);
    final parentContext = navigator.context;
    try {
      final position = _currentPositionValue ?? await _currentPosition(context);
      if (position == null) return;
      final isWithinBranchRange = _isPositionWithinBranchRange(position);
      _updateBranchRangeStatus(position);
      if (!context.mounted) return;
      if (isWithinBranchRange == false) {
        AppConstant.toast(
          context.tr('profile.outsideBranchRange'),
          false,
          context,
        );
        return;
      }

      final succeeded = await widget.cubit.runAttendanceAction(
        action: action,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (!context.mounted) return;
      if (!succeeded) {
        final message = widget.cubit.attendanceActionErrorMessage.isNotEmpty
            ? widget.cubit.attendanceActionErrorMessage
            : context.tr('profile.attendanceActionFailed');
        AppConstant.toast(message, false, context);
        return;
      }

      Navigator.pop(context);
      ProfileClockSuccessDialogWidget.show(parentContext, type: successType);
    } finally {
      if (mounted) {
        setState(() => _loadingAction = null);
      }
    }
  }

  bool _isActionLoading(ProfileAttendanceAction action) {
    return _loadingAction == action;
  }

  Future<void> _loadBranchRangeStatus() async {
    final position = await _currentPosition(context);
    if (!mounted) return;
    if (position == null) {
      setState(() {
        _isCheckingBranchRange = false;
        _isWithinBranchRange = null;
      });
      return;
    }
    _updateBranchRangeStatus(position);
  }

  void _updateBranchRangeStatus(Position position) {
    final isWithinBranchRange = _isPositionWithinBranchRange(position);
    if (!mounted) return;
    setState(() {
      _currentPositionValue = position;
      _isCheckingBranchRange = false;
      _isWithinBranchRange = isWithinBranchRange;
    });
  }

  bool? _isPositionWithinBranchRange(Position position) {
    final profileBranch =
        widget.cubit.profileResponseModel?.customer.branchModel;
    final sessionBranch = widget.cubit.currentAttendanceSession?.branch;
    final branchLatitude = profileBranch?.latitude ?? sessionBranch?.latitude;
    final branchLongitude =
        profileBranch?.longitude ?? sessionBranch?.longitude;
    final branchRangeMeters =
        profileBranch?.attendanceRangeMeters ??
        sessionBranch?.attendanceRangeMeters;
    if (branchLatitude == null ||
        branchLongitude == null ||
        branchRangeMeters == null ||
        branchRangeMeters <= 0) {
      return null;
    }

    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      branchLatitude,
      branchLongitude,
    );
    return distance <= branchRangeMeters;
  }

  Future<Position?> _currentPosition(BuildContext context) async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        if (context.mounted) {
          AppConstant.toast(
            context.tr('profile.locationPermissionRequired'),
            false,
            context,
          );
        }
        return null;
      }

      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          AppConstant.toast(
            context.tr('profile.locationPermissionRequired'),
            false,
            context,
          );
        }
        return null;
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (context.mounted) {
          AppConstant.toast(
            context.tr('profile.locationServiceDisabled'),
            false,
            context,
          );
        }
        return null;
      }

      return Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (_) {
      if (context.mounted) {
        AppConstant.toast(
          context.tr('profile.locationPermissionRequired'),
          false,
          context,
        );
      }
      return null;
    }
  }
}

class _ClockDialogHeaderWidget extends StatelessWidget {
  final String title;

  const _ClockDialogHeaderWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: TextStyles.font16greyColor900Weight600),
        ),
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(4.r),
          child: Icon(Icons.close, size: 18.r, color: AppColors.greyColor600),
        ),
      ],
    );
  }
}

class _ClockBranchInfoWidget extends StatelessWidget {
  final ProfileCubit cubit;

  const _ClockBranchInfoWidget({required this.cubit});

  @override
  Widget build(BuildContext context) {
    final profileBranchName =
        cubit.profileResponseModel?.customer.branchModel.name;
    final sessionBranchName = cubit.currentAttendanceSession?.branch?.name;
    final branchName = profileBranchName?.trim().isNotEmpty == true
        ? profileBranchName!
        : sessionBranchName?.trim().isNotEmpty == true
        ? sessionBranchName!
        : context.tr('branchContact.branchName');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.8.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColorFA, width: .8.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16.r,
                color: AppColors.greenColor500,
              ),
              horizontalSpace(8),
              Expanded(
                child: Text(
                  branchName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font14greyColor900Weight500,
                ),
              ),
            ],
          ),
          verticalSpace(8),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 24.w),
            child: Text(
              context.tr('profile.branchAddress'),
              style: TextStyles.font12greyColorA3W400,
            ),
          ),
          verticalSpace(8),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 24.w),
            child: Row(
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 12.r,
                  color: AppColors.greyColorA3,
                ),
                horizontalSpace(8),
                Text(
                  context.tr('profile.branchWorkingHours'),
                  style: TextStyles.font12greyColorA3W400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BranchRangeWidget extends StatelessWidget {
  final bool isChecking;
  final bool? isWithinRange;

  const _BranchRangeWidget({
    required this.isChecking,
    required this.isWithinRange,
  });

  @override
  Widget build(BuildContext context) {
    final color = isChecking
        ? AppColors.greyColorA3
        : isWithinRange == true
        ? AppColors.greenColor500
        : isWithinRange == false
        ? AppColors.errorColor100
        : AppColors.warningColor1001;
    final titleKey = isChecking
        ? 'profile.checkingBranchRange'
        : isWithinRange == true
        ? 'profile.withinBranchRange'
        : isWithinRange == false
        ? 'profile.outsideBranchRange'
        : 'profile.branchRangeServerCheck';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.r,
          height: 10.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        horizontalSpace(8),
        Text(
          context.tr(titleKey),
          style: TextStyles.font14greenColor500W500.copyWith(color: color),
        ),
      ],
    );
  }
}

class _ClockActionButtonWidget extends StatelessWidget {
  final String title;
  final Color color;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onTap;

  const _ClockActionButtonWidget({
    required this.title,
    required this.color,
    required this.isLoading,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyColor900.withValues(alpha: .06),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: isLoading
            ? SizedBox(
                width: 20.r,
                height: 20.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  color: AppColors.whiteColor,
                ),
              )
            : Text(title, style: TextStyles.font16whiteColorWeight600),
      ),
    );
  }
}

class _ClockDurationWidget extends StatefulWidget {
  final bool isOnBreak;
  final AttendanceSessionModel? session;

  const _ClockDurationWidget({required this.isOnBreak, required this.session});

  @override
  State<_ClockDurationWidget> createState() => _ClockDurationWidgetState();
}

class _ClockDurationWidgetState extends State<_ClockDurationWidget> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() => _now = DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final durationText = _formatDuration(_shiftDuration);
    final breakStartedText = _breakStartedText(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.8.h, horizontal: .8.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColorFA, width: .8.w),
      ),
      child: Column(
        children: [
          Text(
            context.tr('profile.duration'),
            textAlign: TextAlign.center,
            style: TextStyles.font12greyColorA3W400,
          ),
          verticalSpace(4),
          Text(
            durationText,
            textAlign: TextAlign.center,
            style: TextStyles.font24greyColor900Weight600,
          ),
          if (widget.isOnBreak && breakStartedText != null) ...[
            verticalSpace(4),
            Text(
              breakStartedText,
              textAlign: TextAlign.center,
              style: TextStyles.font12greyColorA3W400.copyWith(
                color: AppColors.warningColor1001,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Duration get _shiftDuration {
    final startAt = widget.isOnBreak
        ? widget.session?.breakStartedAt ?? widget.session?.clockInAt
        : widget.session?.clockInAt;
    if (startAt == null || startAt.trim().isEmpty) {
      return Duration.zero;
    }

    final startedAt = _parseDateTime(startAt);
    if (startedAt == null) return Duration.zero;

    final duration = _now.difference(startedAt.toLocal());
    return duration.isNegative ? Duration.zero : duration;
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  String? _breakStartedText(BuildContext context) {
    final breakStartedAt = widget.session?.breakStartedAt;
    if (breakStartedAt == null || breakStartedAt.trim().isEmpty) {
      return null;
    }

    final startedAt = _parseDateTime(breakStartedAt);
    if (startedAt == null) return null;

    final time = AppDateFormat.time(context, startedAt.toLocal());

    return context.tr('profile.onBreakSinceAt', namedArgs: {'time': time});
  }

  DateTime? _parseDateTime(String value) {
    final trimmed = value.trim();
    final parsedDateTime = DateTime.tryParse(trimmed);
    if (parsedDateTime != null) return parsedDateTime;

    final timeParts = trimmed.split(':');
    if (timeParts.length < 2) return null;

    final hour = int.tryParse(timeParts[0]);
    final minute = int.tryParse(timeParts[1]);
    if (hour == null || minute == null) return null;

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}

class _ClockBreakButtonWidget extends StatelessWidget {
  final bool isOnBreak;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onTap;

  const _ClockBreakButtonWidget({
    required this.isOnBreak,
    required this.isLoading,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleKey = isOnBreak ? 'profile.endBreak' : 'profile.takeBreak';

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.warningColor1002,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.warningColor1001, width: 1.w),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyColor900.withValues(alpha: .06),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: isLoading
            ? SizedBox(
                width: 20.r,
                height: 20.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  color: AppColors.warningColor1001,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.free_breakfast_outlined,
                    size: 20.r,
                    color: AppColors.warningColor1001,
                  ),
                  horizontalSpace(8),
                  Text(
                    context.tr(titleKey),
                    style: TextStyles.font16whiteColorWeight600.copyWith(
                      color: AppColors.warningColor1001,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
