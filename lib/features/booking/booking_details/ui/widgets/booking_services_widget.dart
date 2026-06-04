import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingServicesWidget extends StatelessWidget {
  final String serviceName;
  final String duration;
  final String price;
  final String currency;
  final VoidCallback onAddTap;

  const BookingServicesWidget({
    super.key,
    required this.serviceName,
    required this.duration,
    required this.price,
    required this.currency,
    required this.onAddTap,
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
              Text(
                context.tr('myBooking.services'),
                style: TextStyles.font14greyColor900Weight500,
              ),
              Spacer(flex: 1),
              GestureDetector(
                onTap: onAddTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30.r)),
                    color: AppColors.greenColor5005,
                  ),
                  child: Text(
                    '+ ${context.tr('bookingDetails.add')}',
                    style: TextStyles.font12greenColor500W600,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(12),
          Row(
            children: [
              CircleAvatar(
                radius: 3.r,
                backgroundColor: AppColors.greenColor500,
              ),
              horizontalSpace(6),
              Expanded(
                child: Text(
                  serviceName,
                  maxLines: 1,
                  style: TextStyles.font14greyColor900Weight400,
                ),
              ),

              Text(duration, style: TextStyles.font12greyColorA3W400),
              horizontalSpace(12),
              Text(
                '$currency $price',
                style: TextStyles.font14greyColor900Weight600,
              ),
            ],
          ),
          verticalSpace(12),

          Divider(color: AppColors.greyColorF5, thickness: 1),
          verticalSpace(12),
          Row(
            children: [
              Text(
                context.tr('bookingDetails.total'),
                style: TextStyles.font14greyColor900Weight600,
              ),
              Spacer(),
              Text(
                '$currency $price',
                style: TextStyles.font14greyColor900Weight600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
