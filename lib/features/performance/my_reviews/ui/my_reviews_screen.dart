import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/data/models/my_reviews_response_model.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/logic/my_reviews_cubit.dart';
import 'package:new_waqty_employee_app/features/performance/my_reviews/logic/my_reviews_state.dart';

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
      body: SafeArea(
        child: BlocBuilder<MyReviewsCubit, MyReviewsState>(
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
              return _ReviewsErrorState(message: state.message);
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
                  _ReviewsSummary(summary: cubit.reviewsSummary),
                  verticalSpace(20),
                  _ReviewsFilters(
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
                        child: _ReviewCard(review: review),
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
        ),
      ),
    );
  }
}

class _ReviewsFilters extends StatelessWidget {
  final int? selectedRating;
  final ValueChanged<int?> onChanged;

  const _ReviewsFilters({
    required this.selectedRating,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = <int?>[null, 5, 4, 3, 2, 1];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((rating) {
          final isSelected = selectedRating == rating;
          return Padding(
            padding: EdgeInsetsDirectional.only(end: 8.w),
            child: GestureDetector(
              onTap: () => onChanged(rating),
              child: Container(
                height: 34.h,
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.greenColor500
                      : AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.greenColor500
                        : AppColors.greyColor1001.withValues(alpha: .3),
                    width: .8,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.greyColor900.withValues(
                              alpha: .05,
                            ),
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      rating == null ? context.tr('myStats.all') : '$rating',
                      style: TextStyles.font14greenColor500Weight500.copyWith(
                        color: isSelected
                            ? AppColors.whiteColor
                            : AppColors.greenColor500,
                      ),
                    ),
                    if (rating != null) ...[
                      horizontalSpace(4),
                      Icon(
                        Icons.star,
                        color: isSelected
                            ? AppColors.whiteColor
                            : AppColors.greenColor500,
                        size: 12.r,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ReviewsSummary extends StatelessWidget {
  final MyReviewsSummaryModel? summary;

  const _ReviewsSummary({required this.summary});

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

class _ReviewCard extends StatelessWidget {
  final MyReviewModel review;

  const _ReviewCard({required this.review});

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

class _ReviewsErrorState extends StatelessWidget {
  final String message;

  const _ReviewsErrorState({required this.message});

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
