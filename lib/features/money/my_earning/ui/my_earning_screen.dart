import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/logic/my_earning_cubit.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/commission_target_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/estimated_pay_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/my_earning_action_tile_widget.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/my_earning_header_widget.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/my_earning_period_switcher_widget.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/my_earning_summary_row_widget.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/recent_earnings_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/weekly_trend_card_widget.dart';

class MyEarningScreen extends StatelessWidget {
  const MyEarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyEarningCubit(),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MyEarningHeaderWidget(),
                verticalSpace(16),
                const MyEarningPeriodSwitcherWidget(),
                verticalSpace(12),
                const EstimatedPayCardWidget(),
                verticalSpace(12),
                const MyEarningSummaryRowWidget(),
                verticalSpace(12),
                const WeeklyTrendCardWidget(),
                verticalSpace(12),
                const CommissionTargetCardWidget(),
                verticalSpace(12),
                const RecentEarningsCardWidget(),
                verticalSpace(12),
                const MyEarningPayslipsTileWidget(),
                verticalSpace(12),
                const MyEarningBonusesTileWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
