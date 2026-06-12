import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/working_hours_cubit.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/ui/widgets/working_hours_duration_formatter.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/ui/widgets/working_hours_summary_card_widget.dart';

class WorkingHoursSummaryWidget extends StatelessWidget {
  final WorkingHoursCubit cubit;

  const WorkingHoursSummaryWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: WorkingHoursSummaryCardWidget(
            value: WorkingHoursDurationFormatter.format(
              cubit.totalShiftMinutes,
            ),
            label: context.tr('workingHours.shiftTime'),
            valueColor: AppColors.greyColor900,
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: WorkingHoursSummaryCardWidget(
            value: WorkingHoursDurationFormatter.format(
              cubit.totalBreakMinutes,
            ),
            label: context.tr('workingHours.breakTime'),
            valueColor: AppColors.warningColor1001,
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: WorkingHoursSummaryCardWidget(
            value: WorkingHoursDurationFormatter.format(cubit.totalNetMinutes),


            label: context.tr('workingHours.netHours'),
            valueColor: AppColors.greenColor500,
          ),
        ),
      ],
    );
  }
}
