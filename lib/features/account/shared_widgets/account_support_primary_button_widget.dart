import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class AccountSupportPrimaryButtonWidget extends StatelessWidget {
  final String textKey;
  final IconData icon;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;

  const AccountSupportPrimaryButtonWidget({
    super.key,
    required this.textKey,
    required this.icon,
    this.onTap,
    this.padding,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
      child: SizedBox(
        height: 40.h,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : onTap ?? () {},
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.greenColor500,
            disabledBackgroundColor: AppColors.greenColor500,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 18.r,
                  width: 18.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.whiteColor,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: AppColors.whiteColor, size: 16.r),
                    horizontalSpace(8),
                    Text(
                      context.tr(textKey),
                      style: TextStyles.font14whiteColorWeight500.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
