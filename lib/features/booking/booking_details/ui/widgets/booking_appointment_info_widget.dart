import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingAppointmentInfoWidget extends StatelessWidget {
  final String bookingDate;
  final String bookingTime;
  final String roomAddress;
  const BookingAppointmentInfoWidget({
    Key? key,
    required this.bookingDate,
    required this.bookingTime,
    required this.roomAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(
          color: AppColors.greyColor1001.withValues(alpha: .2),
          width: .8,
        ),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: 0.03),
            blurRadius: 16,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: 0.04),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointment Info',
            style: TextStyles.font14greyColor900Weight500,
          ),
          verticalSpace(12),

          Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: AppColors.greyColorF5,
                child: Icon(
                  Icons.access_time,
                  color: AppColors.greyColorA3,
                  size: 16.r,
                ),
              ),
              horizontalSpace(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookingDate,
                      maxLines: 1,
                      style: TextStyles.font14greyColor900Weight500,
                    ),
                    verticalSpace(2),
                    Text(
                      bookingTime,
                      maxLines: 1,
                      style: TextStyles.font12greyColorA3W400,
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(12),
          Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: AppColors.greyColorF5,
                child: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.greyColorA3,
                  size: 16.r,
                ),
              ),
              horizontalSpace(8),
              Expanded(
                child: Text(
                  roomAddress,
                  maxLines: 1,
                  style: TextStyles.font14greyColor900Weight500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
