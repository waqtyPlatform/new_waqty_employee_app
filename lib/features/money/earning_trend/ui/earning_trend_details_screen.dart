import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/ui/widgets/earning_trend_chart_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/ui/widgets/earning_trend_header_widget.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/ui/widgets/earning_trend_period_switcher_widget.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/ui/widgets/earning_trend_recent_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/ui/widgets/earning_trend_summary_row_widget.dart';

class EarningTrendDetailsScreen extends StatelessWidget {
  const EarningTrendDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 28.h),
          child: Column(
            children: [
              const EarningTrendHeaderWidget(),
              verticalSpace(16),
              const EarningTrendPeriodSwitcherWidget(),
              verticalSpace(12),
              const EarningTrendChartCardWidget(),
              verticalSpace(12),
              const EarningTrendSummaryRowWidget(),
              verticalSpace(12),
              const EarningTrendRecentCardWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
