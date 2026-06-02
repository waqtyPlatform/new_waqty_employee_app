import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingCustomerVisitsWidget extends StatelessWidget {
  final String phone;
  final String notes;

  const BookingCustomerVisitsWidget({
    super.key,
    required this.phone,
    required this.notes,
  });

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
          Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: AppColors.greyColorF5,
                child: Icon(
                  Icons.person_outlined,
                  color: AppColors.greyColorA3,
                ),
              ),
              horizontalSpace(8),
              Text('Customer', style: TextStyles.font14greyColor900Weight500),
            ],
          ),
          verticalSpace(12),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(color: AppColors.greyColorF5),
                  color: AppColors.greyColorFA,
                ),
                child: Text(
                  phone.isEmpty ? 'No phone' : phone,
                  style: TextStyles.font12greyColor900Weight500,
                ),
              ),
              horizontalSpace(16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(color: AppColors.greyColorF5),
                  color: AppColors.greyColorFA,
                ),
                child: Text(
                  notes.isEmpty ? 'No notes' : notes,
                  style: TextStyles.font12greyColorA3W400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
