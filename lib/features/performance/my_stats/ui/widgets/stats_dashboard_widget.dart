import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:new_waqty_employee_app/core/utils/spacing.dart';

import 'package:new_waqty_employee_app/features/performance/my_stats/data/models/my_stats_response_model.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/ui/widgets/stats_dashboard_row_widget.dart';

class StatsDashboardWidget extends StatelessWidget {
  final MyStatsKpisModel kpis;

  const StatsDashboardWidget({super.key, required this.kpis});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatsDashboardRowWidget(
          title1: context.tr('myStats.appointments'),
          title2: context.tr('myStats.revenue'),
          value1: '${kpis.appointments.current}',
          value2: kpis.revenue.displayValue,
          change1: _changeLabel(kpis.appointments.percentageChange),
          change2: _changeLabel(kpis.revenue.percentageChange),
          isUp1: _isUp(kpis.appointments.percentageChange),
          isUp2: _isUp(kpis.revenue.percentageChange),
        ),
        verticalSpace(8),
        StatsDashboardRowWidget(
          title1: context.tr('myStats.avgRating'),
          title2: context.tr('myStats.utilization'),
          value1: kpis.rating.displayAverage,
          value2: '${kpis.utilization.percentage.toStringAsFixed(0)}%',
          change1: _changeLabel(kpis.rating.percentageChange),
          change2: _changeLabel(kpis.utilization.percentageChange),
          isUp1: _isUp(kpis.rating.percentageChange),
          isUp2: _isUp(kpis.utilization.percentageChange),
        ),
      ],
    );
  }

  String _changeLabel(double? value) {
    if (value == null) return '';
    final absolute = value.abs();
    return absolute == absolute.roundToDouble()
        ? absolute.toStringAsFixed(0)
        : absolute.toStringAsFixed(1);
  }

  bool? _isUp(double? value) => value == null ? null : value >= 0;
}
