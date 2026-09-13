import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/data/models/my_reviews_response_model.dart';

class MyReviewCardWidget extends StatelessWidget {
  final MyReviewModel review;

  const MyReviewCardWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.greenColor100,
                child: Icon(
                  Icons.person_outline,
                  color: AppColors.greenColor500,
                  size: 25.r,
                ),
              ),
              horizontalSpace(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.customer.name.isEmpty ? '-' : review.customer.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.font14greyColor900Weight600,
                    ),
                    verticalSpace(2),
                    Text(
                      _dateLabel(context),
                      style: TextStyles.font12greyColor500W400,
                    ),
                  ],
                ),
              ),
              _RatingBadge(rating: review.rating),
            ],
          ),
          if (review.comment.isNotEmpty) ...[
            verticalSpace(16),
            Text(
              review.comment,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.font14greyColor500W400.copyWith(height: 1.55),
            ),
          ],
        ],
      ),
    );
  }

  String _dateLabel(BuildContext context) {
    final date = review.createdAt;
    if (date == null) return '';
    return AppDateFormat.relativeDate(context, date);
  }
}

class _RatingBadge extends StatelessWidget {
  final int rating;

  const _RatingBadge({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: AppColors.greenColor505, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, color: AppColors.greenColor500, size: 12.r),
          horizontalSpace(4),
          Text('$rating', style: TextStyles.font14greenColor500Weight500),
        ],
      ),
    );
  }
}
