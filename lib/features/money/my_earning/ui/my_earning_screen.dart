import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/data/repo/my_earning_repo.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/data/services/my_earning_service.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/logic/my_earning_cubit.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/logic/my_earning_state.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/attendance_summary_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/commission_target_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/estimated_pay_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/my_earning_action_tile_widget.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/my_earning_header_widget.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/my_earning_loading_content_widget.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/my_earning_period_switcher_widget.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/my_earning_summary_row_widget.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/recent_earnings_card_widget.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/weekly_trend_card_widget.dart';

class MyEarningScreen extends StatelessWidget {
  const MyEarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;
    return BlocProvider(
      create: (_) => MyEarningCubit(
        MyEarningRepo(MyEarningService(apiConsumer: getIt<ApiConsumer>())),
      )..init(languageCode: languageCode),
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: BlocBuilder<MyEarningCubit, MyEarningState>(
            buildWhen: (previous, current) =>
                current is MyEarningLoadingState ||
                current is MyEarningContentLoadingState ||
                current is MyEarningSuccessState ||
                current is MyEarningErrorState,
            builder: (context, state) {
              final cubit = context.read<MyEarningCubit>();
              if (state is MyEarningErrorState) {
                return _MoneyErrorWidget(
                  message: state.message,
                  onRetry: () => cubit.loadPreview(),
                );
              }
              return RefreshIndicator(
                color: AppColors.greenColor500,
                onRefresh: () async => cubit.refresh(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const MyEarningHeaderWidget(),
                      verticalSpace(16),
                      const MyEarningPeriodSwitcherWidget(),
                      verticalSpace(12),
                      if (cubit.isPreviewLoading) ...[
                        const MyEarningLoadingContentWidget(),
                      ] else ...[
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
                        verticalSpace(12),
                        const MyEarningDeductionsTileWidget(),
                        verticalSpace(12),
                        const AttendanceSummaryCardWidget(),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MoneyErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MoneyErrorWidget({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            verticalSpace(12),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenColor500,
              ),
              child: Text(context.tr('myEarning.retry')),
            ),
          ],
        ),
      ),
    );
  }
}
