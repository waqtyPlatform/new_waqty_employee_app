import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class AppPinButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;

  const AppPinButtonWidget({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
    this.backgroundColor = AppColors.greenColor500,
    this.textColor = AppColors.whiteColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 50.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor ?? backgroundColor),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 22.r,
                  height: 22.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.w,
                    color: textColor,
                  ),
                )
              : Text(
                  text,
                  style: TextStyles.font16whiteColorWeight600.copyWith(
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }
}
