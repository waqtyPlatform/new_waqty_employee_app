import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class MyBookingTabBarWidget extends StatelessWidget {
  final int selectedTabIndex;
  final ValueChanged<int> onTabSelected;

  const MyBookingTabBarWidget({
    super.key,
    required this.selectedTabIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      context.tr('myBooking.upcoming'),
      context.tr('myBooking.completed'),
      context.tr('myBooking.canceled'),
    ];

    return Row(
      children: List.generate(tabs.length, (index) {
        final isSelected = index == selectedTabIndex;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTabSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(color: AppColors.whiteColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    tabs[index],
                    style: TextStyles.font14whiteColorWeight500.copyWith(
                      color: isSelected
                          ? AppColors.greenColor500
                          : AppColors.greyColor300,
                    ),
                  ),
                  verticalSpace(12),
                  Container(
                    width: 80.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.greenColor500
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  Divider(height: 0, color: AppColors.greyColor50),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
