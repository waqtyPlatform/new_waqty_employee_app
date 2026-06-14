import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class ChangeLanguageIconWidget extends StatelessWidget {
  const ChangeLanguageIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (context.locale == const Locale('en', 'US')) {
          await context.setLocale(const Locale('ar', 'EG'));
        } else {
          await context.setLocale(const Locale('en', 'US'));
        }
      },
      child: Container(
        width: 58.w,
        height: 30.h,
        decoration: BoxDecoration(
          color: AppColors.greenColor500,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(microseconds: 600),
              curve: Curves.easeInOut,
              alignment: context.locale == const Locale('en', 'US')
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: 25.r,
                height: 25.r,
                margin: EdgeInsets.symmetric(horizontal: 3.w),

                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      context.locale == const Locale('en', 'US') ? 'EN' : 'ع',
                      style: TextStyles.font14Weight600.copyWith(
                        color: context.locale == const Locale('en', 'US')
                            ? AppColors.greenColor500
                            : AppColors.greenColor500,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      context.locale == const Locale('en', 'US') ? 'ع' : 'EN',
                      style: TextStyles.font14Weight600.copyWith(
                        color: context.locale == const Locale('en', 'US')
                            ? AppColors.whiteColor
                            : AppColors.whiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
