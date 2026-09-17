import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/attendance_session_model.dart';
import 'package:new_waqty_employee_app/features/account/profile/logic/profile_cubit.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_clock_action_dialog_widget.dart';

class ProfileUserWorkTimeWidget extends StatelessWidget {
  final bool isClockedIn;
  final bool isOnBreak;
  final bool isLoading;
  final AttendanceSessionModel? session;

  const ProfileUserWorkTimeWidget({
    super.key,
    required this.isClockedIn,
    this.isOnBreak = false,
    this.isLoading = false,
    this.session,
  });

  @override
  Widget build(BuildContext context) {
    final title = _title(context);
    final subtitle = _subtitle(context);
    final accentColor = isOnBreak
        ? AppColors.warningColor1001
        : AppColors.greenColor500;
    final backgroundColor = isOnBreak
        ? AppColors.warningColor1002
        : AppColors.greenColor5005;
    final borderColor = isOnBreak
        ? AppColors.warningColor1001
        : AppColors.successColor50;
    final iconBackgroundColor = isOnBreak
        ? AppColors.warningColor1002
        : AppColors.greenColor50055;

    return GestureDetector(
      onTap: isLoading
          ? null
          : () => ProfileClockActionDialogWidget.show(
              context,
              isClockedIn: isClockedIn,
              cubit: ProfileCubit.get(context),
              isOnBreak: isOnBreak,
            ),
      child: Container(
        height: 74.6.h,
        padding: EdgeInsets.symmetric(horizontal: 16.8.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderColor, width: 0.8.w),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyColor900.withValues(alpha: .04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: iconBackgroundColor,
              child: isLoading
                  ? SizedBox(
                      width: 16.r,
                      height: 16.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.w,
                        color: accentColor,
                      ),
                    )
                  : Icon(Icons.timer_outlined, color: accentColor, size: 20.r),
            ),
            horizontalSpace(8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyles.font14greyColor900Weight600),
                  verticalSpace(2),
                  Text(
                    subtitle,
                    style: TextStyles.font12greyColorA3W400,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            horizontalSpace(8),
            if (isClockedIn) ...[
              _ActiveStatusPill(isOnBreak: isOnBreak),
              horizontalSpace(8),
            ],
            Icon(Icons.arrow_forward_ios, color: accentColor, size: 16.r),
          ],
        ),
      ),
    );
  }

  String _title(BuildContext context) {
    if (!isClockedIn) return context.tr('profile.clockIn');

    final startedAt = _currentStartedAt;
    if (startedAt == null) {
      return context.tr(
        isOnBreak ? 'profile.breakActiveFallback' : 'home.clockedIn',
      );
    }

    final timeText = AppDateFormat.time(context, startedAt.toLocal());
    if (isOnBreak) {
      return context.tr('profile.breakActiveFallback');
    }

    return context.tr('home.clockedInSince', namedArgs: {'time': timeText});
  }

  String _subtitle(BuildContext context) {
    if (!isClockedIn) return context.tr('profile.tapStartShift');

    if (!isOnBreak) return context.tr('home.active');

    final startedAt = _currentStartedAt;
    if (startedAt == null) {
      return context.tr('profile.breakActiveFallback');
    }

    final duration = DateTime.now().difference(startedAt.toLocal());
    final durationText = _formatDuration(
      duration.isNegative ? Duration.zero : duration,
    );
    final timeText = AppDateFormat.time(context, startedAt.toLocal());

    return context.tr(
      'profile.breakActiveInfo',
      namedArgs: {'time': timeText, 'duration': durationText},
    );
  }

  DateTime? get _currentStartedAt {
    final value = isOnBreak
        ? session?.breakStartedAt ?? session?.clockInAt
        : session?.clockInAt;
    if (value == null || value.trim().isEmpty) return null;
    return DateTime.tryParse(value.trim())?.toLocal();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hours${'profile.durationHour'.tr()} $minutes${'profile.durationMinute'.tr()}';
  }
}

class _ActiveStatusPill extends StatelessWidget {
  final bool isOnBreak;

  const _ActiveStatusPill({required this.isOnBreak});

  @override
  Widget build(BuildContext context) {
    final color = isOnBreak
        ? AppColors.warningColor1001
        : AppColors.greenColor500;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        context.tr(isOnBreak ? 'profile.takeBreak' : 'home.active'),
        style: TextStyles.font12whiteColorWeight600,
      ),
    );
  }
}
