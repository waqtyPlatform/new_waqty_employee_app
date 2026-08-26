import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/logic/earning_trend_cubit.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/logic/earning_trend_state.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/ui/widgets/earning_trend_chart_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/ui/widgets/earning_trend_header_widget.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/ui/widgets/earning_trend_period_switcher_widget.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/ui/widgets/earning_trend_recent_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/ui/widgets/earning_trend_summary_row_widget.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/money_screen_loading_widget.dart';

class EarningTrendDetailsScreen extends StatelessWidget {
  const EarningTrendDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 28.h),
          child: Column(
            children: [
              const EarningTrendHeaderWidget(),
              verticalSpace(16),
              const EarningTrendPeriodSwitcherWidget(),
              verticalSpace(12),
              BlocBuilder<EarningTrendCubit, EarningTrendState>(
                buildWhen: (previous, current) =>
                    current is EarningTrendLoadingState ||
                    current is EarningTrendSuccessState ||
                    current is EarningTrendErrorState,
                builder: (context, state) {
                  if (state is EarningTrendLoadingState) {
                    return const MoneyScreenLoadingWidget(
                      heights: [168, 64, 390],
                    );
                  }
                  if (state is EarningTrendErrorState) {
                    return SizedBox(
                      height: 500.h,
                      child: Center(child: Text(state.message)),
                    );
                  }
                  return Column(
                    children: [
                      const EarningTrendChartCardWidget(),
                      verticalSpace(12),
                      const EarningTrendSummaryRowWidget(),
                      verticalSpace(12),
                      const EarningTrendRecentCardWidget(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
