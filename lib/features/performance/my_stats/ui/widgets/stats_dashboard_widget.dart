import 'package:flutter/material.dart';

import 'package:new_waqty_employee_app/core/utils/spacing.dart';

import 'package:new_waqty_employee_app/features/performance/my_stats/ui/widgets/stats_dashboard_row_widget.dart';

class StatsDashboardWidget extends StatelessWidget {
  const StatsDashboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatsDashboardRowWidget(
          title1: 'Appointments',
          title2: 'Revenue',
          value1: '48',
          value2: 'EGP 12,400',
          change1: '12',
          change2: '12',
          isUp1: false,
          isUp2: true,
        ),
        verticalSpace(8),
        StatsDashboardRowWidget(
          title1: 'Avg Rating',
          title2: 'Utilization',
          value1: '4.7',
          value2: '78%',
          change1: '12',
          change2: '12',
          isUp1: false,
          isUp2: true,
        ),
      ],
    );
  }
}
