import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';

class ChangePinProgressWidget extends StatelessWidget {
  final int activeStep;

  const ChangePinProgressWidget({super.key, required this.activeStep});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4.h,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          final isActive = index == activeStep;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: isActive ? 16.w : 4.r,
                height: 4.r,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.greenColor500
                      : AppColors.greyColorE5,
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              if (index < 2) horizontalSpace(6),
            ],
          );
        }),
      ),
    );
  }
}
