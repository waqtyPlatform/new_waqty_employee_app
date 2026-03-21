import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class MyBookingDaysListWidget extends StatelessWidget {
  final int selectedDayIndex;
  final ValueChanged<int> onDaySelected;

  const MyBookingDaysListWidget({
    super.key,
    required this.selectedDayIndex,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    // Generate the next 14 days starting from today
    final today = DateTime.now();
    final days = List.generate(14, (index) => today.add(Duration(days: index)));

    return SizedBox(
      height: 72.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: days.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = index == selectedDayIndex;
          final dayName = _getDayName(day.weekday);
          final dayNumber = day.day.toString();

          return GestureDetector(
            onTap: () => onDaySelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.greenColor500
                    : AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? AppColors.greenColor500
                      : AppColors.greyColor100,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: isSelected
                        ? TextStyles.font12whiteColorWeight600
                        : TextStyles.font12greyColor500W500,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    dayNumber,
                    style: isSelected
                        ? TextStyles.font16whiteColorWeight600
                        : TextStyles.font16greyColor900Weight600,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }
}
