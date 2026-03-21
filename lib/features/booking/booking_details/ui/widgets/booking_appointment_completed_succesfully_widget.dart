import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingAppointmentCompletedSuccesfullyWidget extends StatelessWidget {
  final String bookingStatus;
  const BookingAppointmentCompletedSuccesfullyWidget({
    super.key,
    required this.bookingStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.greenColor5005,
        border: Border.all(color: AppColors.greenColor50055, width: .8),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: 0.06),
            blurRadius: 2,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: AppColors.greyColorF5,
            child: Icon(
              Icons.check,
              color: AppColors.greenColor500,
              size: 20.sp,
            ),
          ),
          horizontalSpace(8),
          Text(
            'Appointment completed successfully',
            style: TextStyles.font14greenColor500Weight600,
          ),
        ],
      ),
    );
  }
}
