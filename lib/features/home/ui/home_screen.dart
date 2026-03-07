import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';

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
    return Scaffold(
      backgroundColor: AppColors.greyColor900, // Dark background for the top
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Dark Section
            const HomeHeaderWidget(),

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
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HomeSnapshotWidget(),
                      verticalSpace(16),
                      const HomeEarningsWidget(),
                      verticalSpace(16),
                      const HomeUpcomingAppointmentsWidget(),
                      verticalSpace(16),
                      const HomeLatestReviewWidget(),
                      verticalSpace(20), // Extra space at the bottom for scroll
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
