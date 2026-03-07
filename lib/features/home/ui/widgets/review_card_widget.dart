import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class ReviewCardWidget extends StatelessWidget {
  final String reviewerName;
  final String date;
  final String rating;
  final String reviewText;
  final Color avatarColor;

  const ReviewCardWidget({
    Key? key,
    required this.reviewerName,
    required this.date,
    required this.rating,
    required this.reviewText,
    required this.avatarColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColor1001.withOpacity(.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withOpacity(0.03),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.greyColor900.withOpacity(0.04),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: avatarColor,
                child: Icon(
                  Icons.person_outline,
                  color: AppColors.greenColor500,
                  size: 20.r,
                ),
              ),
              horizontalSpace(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reviewerName,
                      maxLines: 1,
                      style: TextStyles.font14greyColor900Weight500,
                    ),
                    verticalSpace(2),
                    Text(date, style: TextStyles.font12greyColor500W400),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(color: AppColors.greenColor505),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.greenColor500,
                      size: 14.r,
                    ),
                    horizontalSpace(4),
                    Text(
                      rating,
                      style: TextStyles.font14greenColor500Weight500,
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(8),
          Text(
            reviewText,
            style: TextStyles.font14greyColor500W400.copyWith(height: 1.5),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
