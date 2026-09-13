import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/logic/my_reviews_cubit.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/logic/my_reviews_state.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/ui/widgets/my_review_card_widget.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/ui/widgets/my_reviews_error_widget.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/ui/widgets/my_reviews_filters_widget.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/ui/widgets/my_reviews_summary_widget.dart';

class MyReviewsBodyWidget extends StatelessWidget {
  const MyReviewsBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyReviewsCubit, MyReviewsState>(
      buildWhen: (previous, current) =>
          current is OnMyReviewsLoadingState ||
          current is OnMyReviewsSuccessState ||
          current is OnMyReviewsLoadingMoreState ||
          current is OnMyReviewsErrorState,
      builder: (context, state) {
        final cubit = MyReviewsCubit.get(context);
        final isInitialLoading =
            state is OnMyReviewsLoadingState && cubit.reviews.isEmpty;
        if (isInitialLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is OnMyReviewsErrorState && cubit.reviews.isEmpty) {
          return MyReviewsErrorWidget(message: state.message);
        }

        return RefreshIndicator(
          onRefresh: () => cubit.loadReviews(
            languageCode: context.locale.languageCode,
            rating: cubit.selectedRating,
            refresh: true,
          ),
          child: ListView(
            controller: cubit.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
            children: [
              MyReviewsSummaryWidget(summary: cubit.reviewsSummary),
              verticalSpace(20),
              MyReviewsFiltersWidget(
                selectedRating: cubit.selectedRating,
                onChanged: (rating) => cubit.loadReviews(
                  languageCode: context.locale.languageCode,
                  rating: rating,
                  refresh: true,
                ),
              ),
              verticalSpace(16),
              if (cubit.reviews.isEmpty)
                SizedBox(
                  height: 300.h,
                  child: Center(
                    child: Text(
                      context.tr('myStats.noReviews'),
                      style: TextStyles.font14greyColor500W500,
                    ),
                  ),
                )
              else
                ...cubit.reviews.map(
                  (review) => Padding(
                    padding: EdgeInsets.only(bottom: 24.h),
                    child: MyReviewCardWidget(review: review),
                  ),
                ),
              if (cubit.isReviewsLoadingMore)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }
}
