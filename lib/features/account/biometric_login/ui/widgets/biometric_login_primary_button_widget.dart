import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class BiometricLoginPrimaryButtonWidget extends StatelessWidget {
  final String titleKey;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  const BiometricLoginPrimaryButtonWidget({
    super.key,
    required this.titleKey,
    required this.icon,
    required this.onTap,
    this.backgroundColor = AppColors.greenColor500,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyColor900.withValues(alpha: .06),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.whiteColor, size: 18.r),
            horizontalSpace(8),
            Flexible(
              child: Text(
                context.tr(titleKey),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.font14whiteColorWeight500.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
