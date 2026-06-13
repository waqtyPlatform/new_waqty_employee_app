import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class BiometricLoginPinCardWidget extends StatelessWidget {
  final VoidCallback? onCompletePreview;

  const BiometricLoginPinCardWidget({super.key, this.onCompletePreview});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCompletePreview,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.greyColorFA, width: .8.w),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyColor900.withValues(alpha: .04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Container(
                    width: 64.w,
                    height: 72.h,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColors.greyColorE5,
                        width: .8.w,
                      ),
                    ),
                  ),
                );
              }),
            ),
            verticalSpace(12),
            Text(
              context.tr('biometricLogin.pinHint'),
              textAlign: TextAlign.center,
              style: TextStyles.font12greyColorA3W400,
            ),
          ],
        ),
      ),
    );
  }
}
