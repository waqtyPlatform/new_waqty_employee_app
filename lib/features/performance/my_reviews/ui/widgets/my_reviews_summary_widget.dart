import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/data/models/my_reviews_response_model.dart';

class MyReviewsSummaryWidget extends StatelessWidget {
  final MyReviewsSummaryModel? summary;

  const MyReviewsSummaryWidget({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final average = summary?.average ?? 0;
    final total = summary?.total ?? 0;
    final filledStars = average.round().clamp(0, 5);

    return Row(
      children: [
        Row(
          children: List.generate(
            5,
            (index) => Padding(
              padding: EdgeInsetsDirectional.only(end: 1.w),
              child: Icon(
                Icons.star,
                size: 17.r,
                color: index < filledStars
                    ? AppColors.warningColor1001
                    : AppColors.greyColor1001,
              ),
            ),
          ),
        ),
        horizontalSpace(8),
        Text(
          _averageLabel(average),
          style: TextStyles.font14greyColor900Weight600,
        ),
        horizontalSpace(8),
        Text(
          context.tr('myStats.totalReviews', namedArgs: {'total': '$total'}),
          style: TextStyles.font12greyColor3003Weight400,
        ),
      ],
    );
  }

  String _averageLabel(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(1);
  }
}
