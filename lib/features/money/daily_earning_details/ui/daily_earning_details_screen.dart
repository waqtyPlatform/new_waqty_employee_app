import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/data/models/daily_earning_details_args.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/ui/widgets/daily_earning_details_header_widget.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/ui/widgets/daily_earning_hero_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/ui/widgets/daily_earning_services_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/ui/widgets/daily_earning_stats_row_widget.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/ui/widgets/daily_earning_summary_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/logic/daily_earning_details_cubit.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/logic/daily_earning_details_state.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/money_screen_loading_widget.dart';

class DailyEarningDetailsScreen extends StatelessWidget {
  final DailyEarningDetailsArgs args;

  const DailyEarningDetailsScreen({super.key, required this.args});

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
              const DailyEarningDetailsHeaderWidget(),
              verticalSpace(16),
              BlocBuilder<DailyEarningDetailsCubit, DailyEarningDetailsState>(
                buildWhen: (previous, current) =>
                    current is DailyEarningDetailsLoadingState ||
                    current is DailyEarningDetailsSuccessState ||
                    current is DailyEarningDetailsErrorState,
                builder: (context, state) {
                  if (state is DailyEarningDetailsLoadingState) {
                    return const MoneyScreenLoadingWidget(
                      heights: [122, 58, 258, 178],
                    );
                  }
                  if (state is DailyEarningDetailsErrorState) {
                    return SizedBox(
                      height: 500.h,
                      child: Center(child: Text(state.message)),
                    );
                  }
                  return Column(
                    children: [
                      DailyEarningHeroCardWidget(args: args),
                      verticalSpace(12),
                      DailyEarningStatsRowWidget(args: args),
                      verticalSpace(12),
                      const DailyEarningServicesCardWidget(),
                      verticalSpace(12),
                      DailyEarningSummaryCardWidget(dayEarnings: args.amount),
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
