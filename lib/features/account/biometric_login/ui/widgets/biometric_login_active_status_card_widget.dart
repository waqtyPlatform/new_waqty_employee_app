import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class BiometricLoginActiveStatusCardWidget extends StatelessWidget {
  const BiometricLoginActiveStatusCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.greenColor5005,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xff99D4BB), width: .8.w),
      ),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: const BoxDecoration(
              color: AppColors.greenColor50055,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 16.r,
              color: AppColors.greenColor500,
            ),
          ),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('biometricLogin.activeOnDevice'),
                  style: TextStyles.font14greenColor500Weight600,
                ),
                verticalSpace(2),
                Text(
                  context.tr('biometricLogin.lastUsed'),
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
