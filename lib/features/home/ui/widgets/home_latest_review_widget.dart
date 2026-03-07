import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'review_card_widget.dart';

class HomeLatestReviewWidget extends StatelessWidget {
  const HomeLatestReviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Latest Review",
                style: TextStyles.font18greyColor900Weight600,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'See All',
                style: TextStyles.font14greenColor500Weight600,
              ),
            ),
          ],
        ),
        verticalSpace(8),
        const ReviewCardWidget(
          reviewerName: 'Rhonda Rhodes',
          date: '3 days ago',
          rating: '3',
          reviewText:
              "It's encouraging to see the government taking proactive steps towards addressing climate change. This legislation demonst...",
          avatarColor: AppColors
              .greenColor100, // Using green color for avatar background
        ),
      ],
    );
  }
}
