import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/data/models/daily_earning_details_args.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/ui/widgets/daily_earning_details_header_widget.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/ui/widgets/daily_earning_hero_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/ui/widgets/daily_earning_services_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/ui/widgets/daily_earning_stats_row_widget.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/ui/widgets/daily_earning_summary_card_widget.dart';

class DailyEarningDetailsScreen extends StatelessWidget {
  final DailyEarningDetailsArgs args;

  const DailyEarningDetailsScreen({super.key, required this.args});

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
              const DailyEarningDetailsHeaderWidget(),
              verticalSpace(16),
              DailyEarningHeroCardWidget(args: args),
              verticalSpace(12),
              DailyEarningStatsRowWidget(args: args),
              verticalSpace(12),
              const DailyEarningServicesCardWidget(),
              verticalSpace(12),
              DailyEarningSummaryCardWidget(dayEarnings: args.amount),
            ],
          ),
        ),
      ),
    );
  }
}
