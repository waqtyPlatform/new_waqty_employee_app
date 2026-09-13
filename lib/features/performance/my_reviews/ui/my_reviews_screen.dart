import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/ui/widgets/my_reviews_body_widget.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leadingWidth: 72.w,
        leading: Padding(
          padding: EdgeInsetsDirectional.only(start: 24.w),
          child: InkWell(
            borderRadius: BorderRadius.circular(40.r),
            onTap: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            child: Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.greyColor1001.withValues(alpha: .6),
                  width: .8,
                ),
              ),
              child: Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Icon(
                  context.locale.languageCode == 'ar'
                      ? Icons.arrow_forward
                      : Icons.arrow_back,
                  color: AppColors.greyColor900,
                  size: 22.r,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          context.tr('myStats.myReviews'),
          style: TextStyles.font18greyColor900Weight600,
        ),
      ),
      body: const SafeArea(child: MyReviewsBodyWidget()),
    );
  }
}
