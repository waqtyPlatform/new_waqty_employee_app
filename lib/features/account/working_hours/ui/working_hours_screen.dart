import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/my_services/ui/widgets/my_services_shimmer_loading.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/models/working_hours_response_model.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/working_hours_cubit.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/working_hours_state.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/ui/widgets/profile_working_hours_items_widget.dart';

class WorkingHoursScreen extends StatefulWidget {
  const WorkingHoursScreen({super.key});

  @override
  State<WorkingHoursScreen> createState() => _WorkingHoursScreenState();
}

class _WorkingHoursScreenState extends State<WorkingHoursScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = WorkingHoursCubit.get(context);
    cubit.clearGetAllWorkingHours();
    cubit.getWorkingHours();
    cubit.scrollListenerMyWorkingHoursScrollController();
  }

  @override
  void dispose() {
    WorkingHoursCubit.get(context).myWorkingHoursScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          child: Column(
            children: [
              const _WorkingHoursHeaderWidget(),
              verticalSpace(16),
              Expanded(
                child: BlocBuilder<WorkingHoursCubit, WorkingHoursState>(
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

                    return Column(
                      children: [
                        _WorkingHoursSummaryWidget(items: items),
                        verticalSpace(14),
                        const _WorkingHoursLegendWidget(),
                        verticalSpace(16),
                        Expanded(
                          child: _WorkingHoursListWidget(
                            cubit: cubit,
                            items: items,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkingHoursHeaderWidget extends StatelessWidget {
  const _WorkingHoursHeaderWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: InkWell(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              borderRadius: BorderRadius.circular(40.r),
              child: Container(
                height: 48.r,
                width: 48.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.whiteColor,
                  border: Border.all(color: AppColors.greyColor50),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.greyColor900,
                  size: 22.r,
                ),
              ),
            ),
          ),
          Text(
            context.tr('workingHours.title'),
            style: TextStyles.font18greyColor900Weight600,
          ),
        ],
      ),
    );
  }
}

class _WorkingHoursSummaryWidget extends StatelessWidget {
  final List<WorkingHoursModel> items;

  const _WorkingHoursSummaryWidget({required this.items});

  @override
  Widget build(BuildContext context) {
    final shiftMinutes = items.fold<int>(
      0,
      (total, item) => total + item.shiftMinutes,
    );
    final breakMinutes = items.fold<int>(
      0,
      (total, item) => total + item.breakMinutes,
    );
    final netMinutes = (shiftMinutes - breakMinutes)
        .clamp(0, shiftMinutes)
        .toInt();

    return Row(
      children: [
        Expanded(
          child: _SummaryCardWidget(
            value: _formatDuration(shiftMinutes),
            label: context.tr('workingHours.shiftTime'),
            valueColor: AppColors.greyColor900,
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _SummaryCardWidget(
            value: _formatDuration(breakMinutes),
            label: context.tr('workingHours.breakTime'),
            valueColor: AppColors.warningColor1001,
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _SummaryCardWidget(
            value: _formatDuration(netMinutes),
            label: context.tr('workingHours.netHours'),
            valueColor: AppColors.greenColor500,
          ),
        ),
      ],
    );
  }
}

class _SummaryCardWidget extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _SummaryCardWidget({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 69.h,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColorFA, width: .8.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyles.font16greyColor900Weight400.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          verticalSpace(4),
          Text(label, style: TextStyles.font10greyColorA3W600),
        ],
      ),
    );
  }
}

class _WorkingHoursLegendWidget extends StatelessWidget {
  const _WorkingHoursLegendWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LegendItemWidget(
          color: AppColors.greenColor500,
          label: context.tr('workingHours.shift'),
        ),
        horizontalSpace(12),
        _LegendItemWidget(
          color: AppColors.warningColor1001,
          label: context.tr('workingHours.breakLabel'),
        ),
      ],
    );
  }
}

class _LegendItemWidget extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItemWidget({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 10.r,
          width: 10.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        horizontalSpace(4),
        Text(label, style: TextStyles.font10greyColorA3w400),
      ],
    );
  }
}

class _WorkingHoursListWidget extends StatelessWidget {
  final WorkingHoursCubit cubit;
  final List<WorkingHoursModel> items;

  const _WorkingHoursListWidget({required this.cubit, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColorFA, width: .8.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.builder(
        controller: cubit.myWorkingHoursScrollController,
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index < items.length) {
            final item = items[index];
            return ProfileWorkingHoursItemsWidget(
              items: item,
              isExpanded: cubit.expandedWorkingHourUuid == item.uuid,
              showDivider: index != items.length - 1,
              onTap: () => cubit.toggleWorkingHour(item.uuid),
            );
          }

          return cubit.myWorkingHoursCurrentPage < cubit.myWorkingHoursLastPage
              ? Padding(
                  padding: EdgeInsets.all(12.r),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.greenColor500,
                    ),
                  ),
                )
              : const SizedBox.shrink();
        },
      ),
    );
  }
}

String _formatDuration(int minutes) {
  final safeMinutes = minutes < 0 ? 0 : minutes;
  final hours = safeMinutes ~/ 60;
  final restMinutes = safeMinutes % 60;
  if (restMinutes == 0) {
    return '${hours}h';
  }
  if (hours == 0) {
    return '${restMinutes}m';
  }
  return '${hours}h ${restMinutes}m';
}
