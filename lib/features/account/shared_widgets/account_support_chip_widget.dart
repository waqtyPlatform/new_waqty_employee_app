import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class AccountSupportChipWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  const AccountSupportChipWidget({
    super.key,
    required this.text,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.greenColor5005 : AppColors.greyColorFA,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: isSelected
                ? AppColors.successColor50
                : AppColors.greyColorF5,
            width: 0.8.w,
          ),
        ),
        child: Text(
          text,
          style: TextStyles.font12greyColor900Weight600.copyWith(
            color: isSelected
                ? AppColors.greenColor500
                : AppColors.greyColor900,
          ),
        ),
      ),
    );
  }
}
