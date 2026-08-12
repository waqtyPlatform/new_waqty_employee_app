import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/home/data/models/home_summary_model.dart';
import 'package:new_waqty_employee_app/features/home/logic/home_cubit.dart';
import 'package:new_waqty_employee_app/features/home/logic/home_state.dart';

import 'widgets/home_header_widget.dart';
import 'widgets/home_search_widget.dart';
import 'widgets/home_snapshot_widget.dart';
import 'widgets/home_earnings_widget.dart';
import 'widgets/home_upcoming_appointments_widget.dart';
import 'widgets/home_latest_review_widget.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        final summary = cubit.summary;

        return Scaffold(
          backgroundColor: AppColors.greyColor900, // Dark background for the top
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Top Dark Section
                HomeHeaderWidget(
                  employeeName: summary?.employeeName ?? '',
                  branchName: summary?.branchName ?? '',
                ),

                const HomeSearchWidget(),
                verticalSpace(24),

                // Bottom White Section
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                    ),
                    child: _buildContent(context, state, summary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    HomeState state,
    HomeSummaryModel? summary,
  ) {
    if (state is OnHomeLoadingState || (summary == null && state is InitialState)) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.greenColor500),
      );
    }

    if (summary == null) {
      return _ErrorView(
        message: state is OnHomeErrorState
            ? state.message
            : context.tr('common.errorMessage'),
        onRetry: () => HomeCubit.get(context).getHomeSummary(),
      );
    }

    return RefreshIndicator(
      color: AppColors.greenColor500,
      onRefresh: () async => HomeCubit.get(context).getHomeSummary(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeSnapshotWidget(
              booked: summary.booked.toString(),
              done: summary.done.toString(),
              left: summary.left.toString(),
              rating: summary.ratingLabel,
            ),
            verticalSpace(16),
            HomeEarningsWidget(amount: summary.earningsLabel),
            verticalSpace(16),
            HomeUpcomingAppointmentsWidget(
              appointments: summary.appointments,
            ),
            verticalSpace(16),
            HomeLatestReviewWidget(review: summary.latestReview),
            verticalSpace(20), // Extra space at the bottom for scroll
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.font14greyColor500W400,
            ),
            verticalSpace(12),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: TextStyles.font14greenColor500Weight600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
