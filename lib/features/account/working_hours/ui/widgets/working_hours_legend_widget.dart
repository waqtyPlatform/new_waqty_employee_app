import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/ui/widgets/working_hours_legend_item_widget.dart';

class WorkingHoursLegendWidget extends StatelessWidget {
  const WorkingHoursLegendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        WorkingHoursLegendItemWidget(
          color: AppColors.greenColor500,
          label: context.tr('workingHours.shift'),
        ),
        horizontalSpace(12),
        WorkingHoursLegendItemWidget(
          color: AppColors.warningColor1001,
          label: context.tr('workingHours.breakLabel'),
        ),
      ],
    );
  }
}
