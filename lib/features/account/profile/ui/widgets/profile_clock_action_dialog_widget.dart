import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/services/location_service.dart';
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
          child: _ClockActionDialogViewport(
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

class _ClockActionDialogViewport extends StatelessWidget {
  final Widget child;

  const _ClockActionDialogViewport({required this.child});

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 16.h,
          bottom: keyboardInset + 16.h,
        ),
        child: Align(
          alignment: keyboardInset > 0 ? Alignment.topCenter : Alignment.center,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const ClampingScrollPhysics(),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _ProfileClockActionDialogWidgetState
    extends State<ProfileClockActionDialogWidget> {
  ProfileAttendanceAction? _loadingAction;
  final TextEditingController _earlyDepartureReasonController =
      TextEditingController();
  Position? _currentPositionValue;
  bool _isCheckingBranchRange = true;
  bool? _isWithinBranchRange;
  bool _isRequestingEarlyDeparture = false;
  bool _forceEarlyDeparturePanel = false;
  bool _forceExpectedEndAtField = false;
  String? _earlyDepartureReasonError;
  DateTime? _expectedEndAt;
  String? _expectedEndAtError;

  @override
  void dispose() {
    _earlyDepartureReasonController.dispose();
    super.dispose();
  }

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
            if (_requiresExpectedEndAt) ...[
              verticalSpace(12),
              _ExpectedEndAtFieldWidget(
                value: _expectedEndAt,
                errorText: _expectedEndAtError,
                onTap: () => _pickExpectedEndAt(context),
              ),
            ],
            if (_shouldShowEarlyDeparturePanel) ...[
              verticalSpace(12),
              _EarlyDeparturePanelWidget(
                earlyDeparture:
                    widget.cubit.currentAttendanceSession?.earlyDeparture,
                reasonController: _earlyDepartureReasonController,
                reasonErrorText: _earlyDepartureReasonError,
                isLoading:
                    _isRequestingEarlyDeparture ||
                    widget.cubit.isEarlyDepartureRequestLoading,
                isDisabled: _loadingAction != null,
                onSubmit: () => _requestEarlyDeparture(context),
              ),
            ],
            if (!widget.isOnBreak && !_isClockOutBlockedByEarlyDeparture) ...[
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

  bool get _shouldShowEarlyDeparturePanel {
    final session = widget.cubit.currentAttendanceSession;
    if (!widget.isClockedIn || widget.isOnBreak || session == null) {
      return false;
    }
    return session.earlyDepartureApprovalRequired ||
        session.earlyDeparture != null ||
        _forceEarlyDeparturePanel;
  }

  bool get _requiresExpectedEndAt {
    if (_forceExpectedEndAtField) return true;
    if (widget.isClockedIn) return false;
    final shifts = widget.cubit.attendanceContext?.shifts;
    if (shifts == null) return false;
    return shifts.where((shift) => !shift.isLeave).isEmpty;
  }

  bool get _isClockOutBlockedByEarlyDeparture {
    final session = widget.cubit.currentAttendanceSession;
    if (_forceEarlyDeparturePanel) return true;
    if (session?.earlyDepartureApprovalRequired != true) return false;
    return session?.earlyDeparture?.isApproved != true;
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
      final attendanceLocation = await _attendanceLocation();
      final position = attendanceLocation.position;
      if (position == null) {
        if (!context.mounted) return;
        _showLocationFailureMessage(context, attendanceLocation.failure);
        return;
      }

      _updateBranchRangeStatus(attendanceLocation);
      if (!context.mounted) return;
      if (attendanceLocation.isWithinBranchRange == false) {
        AppConstant.toast(
          context.tr('profile.outsideBranchRange'),
          false,
          context,
        );
        return;
      }

      final expectedEndAt = _expectedEndAtIsoForAction(action);
      if (_requiresExpectedEndAt && expectedEndAt == null) {
        return;
      }

      final succeeded = await widget.cubit.runAttendanceAction(
        action: action,
        latitude: position.latitude,
        longitude: position.longitude,
        expectedEndAt: expectedEndAt,
      );

      if (!context.mounted) return;
      if (!succeeded) {
        if (action == ProfileAttendanceAction.clockIn &&
            widget.cubit.attendanceExpectedEndAtErrorMessage.isNotEmpty &&
            mounted) {
          setState(() {
            _forceExpectedEndAtField = true;
            _expectedEndAtError =
                widget.cubit.attendanceExpectedEndAtErrorMessage;
          });
        }
        if (widget.cubit.shouldOpenEarlyDepartureRequest && mounted) {
          setState(() => _forceEarlyDeparturePanel = true);
        }
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

  Future<void> _pickExpectedEndAt(BuildContext context) async {
    final serverNow = _serverNowWallClock;
    final initial = _expectedEndAt ?? serverNow.add(const Duration(hours: 8));
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(serverNow.year, serverNow.month, serverNow.day),
      lastDate: serverNow.add(const Duration(days: 1)),
      builder: _pickerThemeBuilder,
    );
    if (pickedDate == null || !context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
      builder: (context, child) => _pickerThemeBuilder(
        context,
        MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
    if (pickedTime == null) return;

    final selected = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
    setState(() {
      _expectedEndAt = selected;
      _expectedEndAtError = _validateExpectedEndAt(selected);
    });
  }

  String? _expectedEndAtIsoForAction(ProfileAttendanceAction action) {
    if (action != ProfileAttendanceAction.clockIn || !_requiresExpectedEndAt) {
      return null;
    }

    final selected = _expectedEndAt;
    if (selected == null) {
      setState(() {
        _expectedEndAtError = context.tr('profile.expectedEndAtRequired');
      });
      return null;
    }

    final validationError = _validateExpectedEndAt(selected);
    if (validationError != null) {
      setState(() => _expectedEndAtError = validationError);
      return null;
    }

    setState(() => _expectedEndAtError = null);
    return _toAttendanceContextUtcIso(selected);
  }

  String? _validateExpectedEndAt(DateTime selected) {
    final serverNow = _serverNowWallClock;
    if (!selected.isAfter(serverNow)) {
      return context.tr('profile.expectedEndAtFuture');
    }
    if (selected.difference(serverNow) > const Duration(hours: 24)) {
      return context.tr('profile.expectedEndAtMax24');
    }
    return null;
  }

  DateTime get _serverNowWallClock {
    final serverTime = widget.cubit.attendanceContext?.serverTime;
    if (serverTime == null || serverTime.trim().isEmpty) return DateTime.now();
    return AppDateFormat.parseBackendDateTime(serverTime) ?? DateTime.now();
  }

  String _toAttendanceContextUtcIso(DateTime selected) {
    final offset = _serverOffset;
    if (offset == null) return selected.toUtc().toIso8601String();
    return DateTime.utc(
      selected.year,
      selected.month,
      selected.day,
      selected.hour,
      selected.minute,
    ).subtract(offset).toIso8601String();
  }

  Duration? get _serverOffset {
    final serverTime = widget.cubit.attendanceContext?.serverTime ?? '';
    final match = RegExp(r'([+-])(\d{2}):?(\d{2})$').firstMatch(serverTime);
    if (match == null) return null;
    final sign = match.group(1) == '-' ? -1 : 1;
    final hours = int.tryParse(match.group(2) ?? '');
    final minutes = int.tryParse(match.group(3) ?? '');
    if (hours == null || minutes == null) return null;
    return Duration(minutes: sign * ((hours * 60) + minutes));
  }

  Widget _pickerThemeBuilder(BuildContext context, Widget? child) {
    final baseTheme = Theme.of(context);
    final colorScheme = baseTheme.colorScheme.copyWith(
      primary: AppColors.greenColor500,
      onPrimary: AppColors.whiteColor,
      secondary: AppColors.greenColor500,
      surface: AppColors.whiteColor,
      onSurface: AppColors.greyColor900,
    );
    return Theme(
      data: baseTheme.copyWith(
        colorScheme: colorScheme,
        dialogTheme: baseTheme.dialogTheme.copyWith(
          backgroundColor: AppColors.whiteColor,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.greenColor500,
            textStyle: TextStyles.font14greenColor500W500,
          ),
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: AppColors.whiteColor,
          headerBackgroundColor: AppColors.whiteColor,
          headerForegroundColor: AppColors.greyColor900,
          surfaceTintColor: AppColors.whiteColor,
          todayForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.whiteColor;
            }
            return AppColors.greenColor500;
          }),
          todayBorder: const BorderSide(color: AppColors.greenColor500),
          dayForegroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.whiteColor;
            }
            return AppColors.greyColor900;
          }),
          dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.greenColor500;
            }
            return null;
          }),
        ),
        timePickerTheme: TimePickerThemeData(
          backgroundColor: AppColors.whiteColor,
          dialHandColor: AppColors.greenColor500,
          dialBackgroundColor: AppColors.greenColor5005,
          hourMinuteColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.greenColor500;
            }
            return AppColors.greyColorFA;
          }),
          hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.whiteColor;
            }
            return AppColors.greyColor900;
          }),
          dayPeriodColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.greenColor500;
            }
            return AppColors.greyColorFA;
          }),
          dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.whiteColor;
            }
            return AppColors.greyColor900;
          }),
        ),
      ),
      child: child ?? const SizedBox.shrink(),
    );
  }

  Future<void> _requestEarlyDeparture(BuildContext context) async {
    if (_isRequestingEarlyDeparture ||
        widget.cubit.isEarlyDepartureRequestLoading) {
      return;
    }

    final reason = _earlyDepartureReasonController.text.trim();
    if (reason.isEmpty) {
      AppConstant.toast(
        context.tr('profile.earlyDepartureReasonRequired'),
        false,
        context,
      );
      return;
    }

    if (reason.length > 1000) {
      AppConstant.toast(
        context.tr('profile.earlyDepartureReasonTooLong'),
        false,
        context,
      );
      return;
    }

    setState(() {
      _isRequestingEarlyDeparture = true;
      _earlyDepartureReasonError = null;
    });
    try {
      final succeeded = await widget.cubit.requestEarlyDeparture(
        reason: reason,
      );
      if (!context.mounted) return;
      if (succeeded) {
        _earlyDepartureReasonController.clear();
        AppConstant.toast(
          context.tr('profile.earlyDepartureRequestSent'),
          true,
          context,
        );
        return;
      }

      final message = widget.cubit.earlyDepartureRequestErrorMessage.isNotEmpty
          ? widget.cubit.earlyDepartureRequestErrorMessage
          : context.tr('profile.earlyDepartureRequestFailed');
      if (mounted) {
        setState(() => _earlyDepartureReasonError = message);
      }
      AppConstant.toast(message, false, context);
    } finally {
      if (mounted) {
        setState(() => _isRequestingEarlyDeparture = false);
      }
    }
  }

  Future<void> _loadBranchRangeStatus() async {
    final attendanceLocation = await _attendanceLocation();
    if (!mounted) return;
    if (attendanceLocation.position == null) {
      setState(() {
        _isCheckingBranchRange = false;
        _isWithinBranchRange = null;
      });
      return;
    }
    _updateBranchRangeStatus(attendanceLocation);
  }

  void _updateBranchRangeStatus(AttendanceLocationResult attendanceLocation) {
    final position = attendanceLocation.position;
    if (position == null) return;
    if (!mounted) return;
    setState(() {
      _currentPositionValue = position;
      _isCheckingBranchRange = false;
      _isWithinBranchRange = attendanceLocation.isWithinBranchRange;
    });
  }

  Future<AttendanceLocationResult> _attendanceLocation() {
    final cachedPosition = _currentPositionValue;
    if (cachedPosition != null) {
      final distance = YourLocation.distanceFromPositionToBranch(
        position: cachedPosition,
        branchLatitude: _branchLatitude,
        branchLongitude: _branchLongitude,
      );
      return Future.value(
        AttendanceLocationResult(
          position: cachedPosition,
          distanceMeters: distance,
          isWithinBranchRange: YourLocation.isWithinBranchRange(
            distanceMeters: distance,
            branchRangeMeters: _branchRangeMeters,
          ),
        ),
      );
    }

    return YourLocation.getAttendanceLocation(
      branchLatitude: _branchLatitude,
      branchLongitude: _branchLongitude,
      branchRangeMeters: _branchRangeMeters,
    );
  }

  double? get _branchLatitude {
    final profileBranch =
        widget.cubit.profileResponseModel?.customer.branchModel;
    final sessionBranch = widget.cubit.currentAttendanceSession?.branch;
    final contextBranch = widget.cubit.attendanceContext?.branch;
    return contextBranch?.latitude ??
        sessionBranch?.latitude ??
        profileBranch?.latitude;
  }

  double? get _branchLongitude {
    final profileBranch =
        widget.cubit.profileResponseModel?.customer.branchModel;
    final sessionBranch = widget.cubit.currentAttendanceSession?.branch;
    final contextBranch = widget.cubit.attendanceContext?.branch;
    return contextBranch?.longitude ??
        sessionBranch?.longitude ??
        profileBranch?.longitude;
  }

  double? get _branchRangeMeters {
    final profileBranch =
        widget.cubit.profileResponseModel?.customer.branchModel;
    final sessionBranch = widget.cubit.currentAttendanceSession?.branch;
    final contextBranch = widget.cubit.attendanceContext?.branch;
    return contextBranch?.attendanceRangeMeters ??
        sessionBranch?.attendanceRangeMeters ??
        profileBranch?.attendanceRangeMeters;
  }

  void _showLocationFailureMessage(
    BuildContext context,
    LocationFailure? failure,
  ) {
    final messageKey = failure == LocationFailure.serviceDisabled
        ? 'profile.locationServiceDisabled'
        : 'profile.locationPermissionRequired';
    AppConstant.toast(context.tr(messageKey), false, context);
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
    final contextBranchName = cubit.attendanceContext?.branch?.name;
    final branchName = contextBranchName?.trim().isNotEmpty == true
        ? contextBranchName!
        : sessionBranchName?.trim().isNotEmpty == true
        ? sessionBranchName!
        : profileBranchName?.trim().isNotEmpty == true
        ? profileBranchName!
        : context.tr('branchContact.branchName');
    final address =
        _branchAddress ?? context.tr('profile.branchAddressUnavailable');
    final shiftTime =
        _shiftTime(context) ?? context.tr('profile.shiftTimeUnavailable');

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
            child: Text(address, style: TextStyles.font12greyColorA3W400),
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
                Expanded(
                  child: Text(
                    shiftTime,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font12greyColorA3W400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? get _branchAddress {
    final profileBranch = cubit.profileResponseModel?.customer.branchModel;
    final sessionBranch = cubit.currentAttendanceSession?.branch;
    final contextBranch = cubit.attendanceContext?.branch;
    return _firstNonEmpty([
      contextBranch?.address,
      sessionBranch?.address,
      profileBranch?.address,
    ]);
  }

  String? _shiftTime(BuildContext context) {
    final session = cubit.currentAttendanceSession;
    final contextShiftTimes = cubit.attendanceContext?.shifts
        .where((shift) => !shift.isLeave)
        .map((shift) => _timeRange(context, shift.startAt, shift.endAt))
        .whereType<String>()
        .toList();
    if (contextShiftTimes != null && contextShiftTimes.isNotEmpty) {
      return contextShiftTimes.join(' • ');
    }

    final sessionStart = _formatTime(context, session?.startTime);
    final sessionEnd = _formatTime(context, session?.endTime);
    if (sessionStart != null && sessionEnd != null) {
      return _translatedTimeRange(context, sessionStart, sessionEnd);
    }

    return null;
  }

  String? _timeRange(BuildContext context, String? start, String? end) {
    final startText = _formatAbsoluteTime(context, start);
    final endText = _formatAbsoluteTime(context, end);
    if (startText == null || endText == null) return null;
    return _translatedTimeRange(context, startText, endText);
  }

  String _translatedTimeRange(BuildContext context, String start, String end) {
    return context.tr(
      'date.patterns.timeRange',
      namedArgs: {'start': start, 'end': end},
    );
  }

  String? _formatAbsoluteTime(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsedDateTime = DateTime.tryParse(value.trim());
    if (parsedDateTime == null) return AppDateFormat.timeOfDay(context, value);
    return AppDateFormat.time(context, parsedDateTime.toLocal());
  }

  String? _formatTime(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsedDateTime = AppDateFormat.parseBackendDateTime(value);
    if (parsedDateTime != null) {
      return AppDateFormat.time(context, parsedDateTime);
    }
    return AppDateFormat.timeOfDay(context, value);
  }

  String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    }
    return null;
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

class _ExpectedEndAtFieldWidget extends StatelessWidget {
  final DateTime? value;
  final String? errorText;
  final VoidCallback onTap;

  const _ExpectedEndAtFieldWidget({
    required this.value,
    required this.errorText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selectedValue = value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: errorText == null
                    ? AppColors.greyColor1001
                    : AppColors.errorColor100,
                width: .8.w,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.event_available_outlined,
                  size: 18.r,
                  color: AppColors.greenColor500,
                ),
                horizontalSpace(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr('profile.expectedEndAtLabel'),
                        style: TextStyles.font12greyColorA3W400,
                      ),
                      verticalSpace(4),
                      Text(
                        selectedValue == null
                            ? context.tr('profile.expectedEndAtHint')
                            : AppDateFormat.dayMonthTime(
                                context,
                                selectedValue,
                              ),
                        style: TextStyles.font14greyColor900Weight500.copyWith(
                          color: selectedValue == null
                              ? AppColors.greyColorA3
                              : AppColors.greyColor900,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20.r,
                  color: AppColors.greyColorA3,
                ),
              ],
            ),
          ),
        ),
        if (errorText != null && errorText!.trim().isNotEmpty) ...[
          verticalSpace(6),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 4.w),
            child: Text(
              errorText!,
              style: TextStyles.font12greyColorA3W400.copyWith(
                color: AppColors.errorColor100,
                height: 1.35,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _EarlyDeparturePanelWidget extends StatelessWidget {
  final EarlyDepartureModel? earlyDeparture;
  final TextEditingController reasonController;
  final String? reasonErrorText;
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onSubmit;

  const _EarlyDeparturePanelWidget({
    required this.earlyDeparture,
    required this.reasonController,
    this.reasonErrorText,
    required this.isLoading,
    required this.isDisabled,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final status = earlyDeparture?.status ?? '';
    final statusColor = _statusColor(status);
    final canRequest =
        earlyDeparture == null ||
        earlyDeparture?.isRejected == true ||
        earlyDeparture?.isExpired == true;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.greyColorFA,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: statusColor.withValues(alpha: .35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.assignment_outlined, size: 16.r, color: statusColor),
              horizontalSpace(8),
              Expanded(
                child: Text(
                  context.tr('profile.earlyDepartureTitle'),
                  style: TextStyles.font14greyColor900Weight500,
                ),
              ),
            ],
          ),
          verticalSpace(8),
          Text(
            _statusText(context),
            style: TextStyles.font12greyColor500W400.copyWith(
              color: statusColor,
              height: 1.4,
            ),
          ),
          if ((earlyDeparture?.reviewReason ?? '').trim().isNotEmpty) ...[
            verticalSpace(6),
            Text(
              earlyDeparture!.reviewReason!,
              style: TextStyles.font12greyColorA3W400.copyWith(height: 1.4),
            ),
          ],
          if (canRequest) ...[
            verticalSpace(10),
            TextField(
              controller: reasonController,
              minLines: 2,
              maxLines: 4,
              maxLength: 1000,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                counterText: '',
                hintText: context.tr('profile.earlyDepartureReasonHint'),
                errorText: reasonErrorText,
                errorMaxLines: 3,
                hintStyle: TextStyles.font12greyColorA3W400,
                filled: true,
                fillColor: AppColors.whiteColor,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: AppColors.greyColorE5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: AppColors.greyColorE5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: AppColors.greenColor500),
                ),
              ),
            ),
            verticalSpace(10),
            _EarlyDepartureButtonWidget(
              isLoading: isLoading,
              isDisabled: isDisabled,
              onTap: onSubmit,
            ),
          ],
        ],
      ),
    );
  }

  String _statusText(BuildContext context) {
    if (earlyDeparture?.isPending == true) {
      return context.tr('profile.earlyDeparturePending');
    }
    if (earlyDeparture?.isApproved == true) {
      return context.tr('profile.earlyDepartureApproved');
    }
    if (earlyDeparture?.isRejected == true) {
      return context.tr('profile.earlyDepartureRejected');
    }
    if (earlyDeparture?.isExpired == true) {
      return context.tr('profile.earlyDepartureExpired');
    }
    return context.tr('profile.earlyDepartureRequired');
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warningColor1001;
      case 'approved':
        return AppColors.greenColor500;
      case 'rejected':
        return AppColors.errorColor100;
      case 'expired':
        return AppColors.greyColor500;
      default:
        return AppColors.warningColor1001;
    }
  }
}

class _EarlyDepartureButtonWidget extends StatelessWidget {
  final bool isLoading;
  final bool isDisabled;
  final VoidCallback onTap;

  const _EarlyDepartureButtonWidget({
    required this.isLoading,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled || isLoading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 42.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.greenColor500,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: isLoading
            ? SizedBox(
                width: 18.r,
                height: 18.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2.w,
                  color: AppColors.whiteColor,
                ),
              )
            : Text(
                context.tr('profile.earlyDepartureRequestButton'),
                style: TextStyles.font16whiteColorWeight600,
              ),
      ),
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
