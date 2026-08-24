import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/logic/my_stats_cubit.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/logic/my_stats_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/ui/my_reviews_screen.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/ui/widgets/stats_appointments_overview_widget.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/ui/widgets/stats_comparison_widget.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/ui/widgets/stats_dashboard_widget.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/ui/widgets/stats_filter_widget.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/ui/widgets/stats_reveniew_trend_widget.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/ui/widgets/stats_reviews_summary_widget.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/ui/widgets/stats_services_widget.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/ui/widgets/stats_utilization_details_widget.dart';

class MyStatsScreen extends StatefulWidget {
  const MyStatsScreen({super.key});

  @override
  State<MyStatsScreen> createState() => _MyStatsScreenState();
}

class _MyStatsScreenState extends State<MyStatsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MyStatsCubit.get(
        context,
      ).loadPerformance(languageCode: context.locale.languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          context.tr('myStats.title'),
          style: TextStyles.font18greyColor900Weight600,
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<MyStatsCubit, MyStatsState>(
          buildWhen: (previous, current) {
            return current is InitialState ||
                current is OnMyStatsLoadingState ||
                current is OnMyStatsSuccessState ||
                current is OnMyStatsErrorState ||
                current is OnMyStatsCatchErrorState;
          },
          builder: (context, state) {
            final cubit = MyStatsCubit.get(context);
            final performance = cubit.performance;
            final isInitialLoading =
                state is OnMyStatsLoadingState && performance == null;
            if (isInitialLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (performance == null) {
              return _StatsErrorState(
                message: state is OnMyStatsErrorState
                    ? state.message
                    : cubit.errorMessage,
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(16),
                  StatsFilterWidget(
                    selectedIndex: cubit.selectedTabIndex,
                    onFilterSelected: (index) {
                      cubit.changeSelectedTab(
                        index,
                        languageCode: context.locale.languageCode,
                      );
                    },
                  ),
                  verticalSpace(16),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => cubit.refresh(
                        languageCode: context.locale.languageCode,
                      ),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            StatsDashboardWidget(kpis: performance.kpis),
                            verticalSpace(12),
                            StatsAppointmentsOverviewWidget(
                              series: performance.appointmentsSeries,
                            ),
                            verticalSpace(12),
                            StatsReveniewTrendWidget(
                              series: performance.revenueSeries,
                            ),
                            verticalSpace(12),
                            StatsServicesWidget(services: performance.services),
                            verticalSpace(12),
                            StatsUtilizationDetailsWidget(
                              utilization: performance.kpis.utilization,
                              hasEstimatedData: performance
                                  .dataQuality
                                  .hasEstimatedUtilization,
                            ),
                            verticalSpace(12),
                            StatsReviewsSummaryWidget(
                              summary: performance.reviewsSummary,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: cubit,
                                    child: const MyReviewsScreen(),
                                  ),
                                ),
                              ),
                            ),
                            verticalSpace(12),
                            StatsComparisonWidget(
                              comparison: performance.comparison,
                            ),
                            verticalSpace(12),
                          ],
                        ),
                      ),
                    ),
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

class _StatsErrorState extends StatelessWidget {
  final String message;

  const _StatsErrorState({required this.message});

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
              onPressed: () => MyStatsCubit.get(
                context,
              ).loadPerformance(languageCode: context.locale.languageCode),
              child: Text(context.tr('common.retry')),
            ),
          ],
        ),
      ),
    );
  }
}
