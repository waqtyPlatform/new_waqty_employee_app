import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';

BoxDecoration myEarningCardDecoration() {
  return BoxDecoration(
    color: AppColors.whiteColor,
    borderRadius: BorderRadius.circular(10.r),
    border: Border.all(
      color: AppColors.greyColor100.withValues(alpha: .2),
      width: .8.w,
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.greyColor900.withValues(alpha: .04),
        blurRadius: 4,
        offset: const Offset(0, 1),
      ),
    ],
  );
}
