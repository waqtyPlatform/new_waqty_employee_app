import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/logic/my_stats_cubit.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/logic/my_stats_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/ui/widgets/stats_appointments_overview_widget.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/ui/widgets/stats_dashboard_widget.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/ui/widgets/stats_filter_widget.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/ui/widgets/stats_reveniew_trend_widget.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/ui/widgets/stats_services_widget.dart';

class MyStatsScreen extends StatelessWidget {
  const MyStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          'My Performance',
          style: TextStyles.font18greyColor900Weight600,
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<MyStatsCubit, MyStatsState>(
          buildWhen: (previous, current) {
            return current is InitialState;
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(16),
                  StatsFilterWidget(
                    selectedIndex: MyStatsCubit.get(context).selectedTabIndex,
                    onFilterSelected: (index) {
                      MyStatsCubit.get(context).changeSelectedTab(index);
                    },
                  ),
                  verticalSpace(16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StatsDashboardWidget(),
                          verticalSpace(12),
                          StatsAppointmentsOverviewWidget(
                            heightValueInGraph: 20,
                          ),
                          verticalSpace(12),
                          StatsReveniewTrendWidget(maxValue: 1800),
                          verticalSpace(12),
                          StatsServicesWidget(),
                          verticalSpace(12),

                          ///
                          verticalSpace(12),
                        ],
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
