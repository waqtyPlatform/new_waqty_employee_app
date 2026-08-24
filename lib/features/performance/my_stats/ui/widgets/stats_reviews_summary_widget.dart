import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/models/my_stats_response_model.dart';

class StatsReviewsSummaryWidget extends StatelessWidget {
  final MyStatsReviewsSummaryModel summary;
  final VoidCallback onTap;

  const StatsReviewsSummaryWidget({
    super.key,
    required this.summary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: AppColors.greyColor1001.withValues(alpha: .2),
            width: .8,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyColor900.withValues(alpha: .04),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
            BoxShadow(
              color: AppColors.greyColor900.withValues(alpha: .05),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 24.r,
              height: 24.r,
              decoration: const BoxDecoration(
                color: AppColors.warningColor1002,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.star_rounded,
                color: AppColors.warningColor3003,
                size: 18.r,
              ),
            ),
            horizontalSpace(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('myStats.myReviews'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font14greyColor900Weight500,
                  ),
                  verticalSpace(2),
                  Text(
                    context.tr(
                      'myStats.reviewsSummary',
                      namedArgs: {
                        'average': summary.displayAverage,
                        'total': '${summary.total}',
                      },
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font12greyColorA3W400,
                  ),
                ],
              ),
            ),
            Icon(
              context.locale.languageCode == 'ar'
                  ? Icons.chevron_left
                  : Icons.chevron_right,
              color: AppColors.greyColorA3,
              size: 22.r,
            ),
          ],
        ),
      ),
    );
  }
}
