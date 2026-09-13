import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/features/home/data/models/home_summary_model.dart';
import 'review_card_widget.dart';

class HomeLatestReviewWidget extends StatelessWidget {
  final HomeReviewModel? review;

  const HomeLatestReviewWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final latest = review;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                context.tr('home.latestReview'),
                style: TextStyles.font18greyColor900Weight600,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, Routes.myReviewsScreen),
              child: Text(
                context.tr('home.seeAll'),
                style: TextStyles.font14greenColor500Weight600,
              ),
            ),
          ],
        ),
        verticalSpace(8),
        if (latest == null)
          Text(
            context.tr('home.noReviewsYet'),
            style: TextStyles.font14greyColor500W400,
          )
        else
          ReviewCardWidget(
            reviewerName: latest.reviewerName.isEmpty
                ? context.tr('home.anonymousCustomer')
                : latest.reviewerName,
            date: latest.relativeDateLabel,
            rating: latest.rating.toString(),
            reviewText: latest.comment,
            avatarColor: AppColors.greenColor100,
          ),
      ],
    );
  }
}
