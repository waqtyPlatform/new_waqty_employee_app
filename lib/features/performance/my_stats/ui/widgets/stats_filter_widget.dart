import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class StatsFilterWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onFilterSelected;

  const StatsFilterWidget({
    super.key,
    required this.selectedIndex,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['Today', 'Week', 'Month'];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.greyColor25.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(
          color: AppColors.greyColor1001.withValues(alpha: .1),
          width: .8,
        ),
      ),
      child: Row(
        children: List.generate(filters.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onFilterSelected(index),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.whiteColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(50.r),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.greyColor900.withValues(
                              alpha: 0.04,
                            ),
                            blurRadius: 2,
                            spreadRadius: 0,
                            offset: const Offset(0, 1),
                          ),
                          BoxShadow(
                            color: AppColors.greyColor900.withValues(
                              alpha: 0.05,
                            ),
                            blurRadius: 3,
                            spreadRadius: 0,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    filters[index],
                    style: TextStyles.font12greyColor900Weight600.copyWith(
                      color: isSelected
                          ? AppColors.greyColor900
                          : AppColors.greyColorA3,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
