import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/my_services/ui/widgets/my_services_shimmer_loading.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/working_hours_cubit.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/working_hours_state.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/ui/widgets/working_hours_legend_widget.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/ui/widgets/working_hours_list_widget.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/ui/widgets/working_hours_summary_widget.dart';

class WorkingHoursContentWidget extends StatelessWidget {
  const WorkingHoursContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkingHoursCubit, WorkingHoursState>(
      buildWhen: (previous, current) =>
          current is GetWorkingHoursLoadingState ||
          current is GetWorkingHoursSuccessState ||
          current is GetWorkingHoursErrorState ||
          current is GetWorkingHoursCatchErrorState ||
          current is WorkingHoursExpandedChangedState,
      builder: (context, state) {
        final cubit = WorkingHoursCubit.get(context);
        final items = cubit.myWorkingHours;

        if (items.isEmpty && state is GetWorkingHoursLoadingState) {
          return const MyServicesShimmerLoading();
        }

        if (items.isEmpty) {
          return Center(
            child: Text(
              context.tr('workingHours.noWorkingHoursFound'),
              style: TextStyles.font16greyColor900Weight400,
            ),
          );
        }

        return RefreshIndicator(
          color: AppColors.greenColor500,
          onRefresh: () async {
            cubit.clearGetAllWorkingHours();
            cubit.getWorkingHours(languageCode: context.locale.languageCode);
          },
          child: Column(
            children: [
              WorkingHoursSummaryWidget(cubit: cubit),
              verticalSpace(14),
              const WorkingHoursLegendWidget(),
              verticalSpace(16),
              Expanded(
                child: WorkingHoursListWidget(cubit: cubit, items: items),
              ),
            ],
          ),
        );
      },
    );
  }
}
