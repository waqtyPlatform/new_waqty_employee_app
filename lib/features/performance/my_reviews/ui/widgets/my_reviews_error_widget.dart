import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/logic/my_reviews_cubit.dart';

class MyReviewsErrorWidget extends StatelessWidget {
  final String message;

  const MyReviewsErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.isEmpty ? context.tr('common.errorMessage') : message,
              textAlign: TextAlign.center,
              style: TextStyles.font14greyColor500W500,
            ),
            verticalSpace(12),
            TextButton(
              onPressed: () => MyReviewsCubit.get(
                context,
              ).loadReviews(languageCode: context.locale.languageCode),
              child: Text(context.tr('common.retry')),
            ),
          ],
        ),
      ),
    );
  }
}
