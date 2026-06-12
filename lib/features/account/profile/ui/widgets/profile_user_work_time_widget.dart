import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_clock_action_dialog_widget.dart';

class ProfileUserWorkTimeWidget extends StatelessWidget {
  final bool isClockedIn;

  const ProfileUserWorkTimeWidget({super.key, required this.isClockedIn});

  @override
  Widget build(BuildContext context) {
    final titleKey = isClockedIn ? 'profile.clockOut' : 'profile.clockIn';
    final subtitleKey = isClockedIn
        ? 'profile.clockedInInfo'
        : 'profile.tapStartShift';
    final accentColor = isClockedIn
        ? AppColors.errorColor2002
        : AppColors.greenColor500;
    final backgroundColor = isClockedIn
        ? AppColors.errorColor2003
        : AppColors.greenColor5005;
    final borderColor = isClockedIn
        ? AppColors.errorColor20033
        : AppColors.successColor50;
    final iconBackgroundColor = isClockedIn
        ? AppColors.errorColor20033
        : AppColors.greenColor50055;

    return GestureDetector(
      onTap: () => ProfileClockActionDialogWidget.show(
        context,
        isClockedIn: isClockedIn,
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
              child: Icon(Icons.timer_outlined, color: accentColor, size: 20.r),
            ),
            horizontalSpace(8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr(titleKey),
                    style: TextStyles.font14greyColor900Weight600,
                  ),
                  verticalSpace(2),
                  Text(
                    context.tr(subtitleKey),
                    style: TextStyles.font12greyColorA3W400,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            horizontalSpace(8),
            Icon(Icons.arrow_forward_ios, color: accentColor, size: 16.r),
          ],
        ),
      ),
    );
  }
}
