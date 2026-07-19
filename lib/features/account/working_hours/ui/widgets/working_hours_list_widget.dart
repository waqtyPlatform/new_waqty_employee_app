import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/models/working_hours_response_model.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/working_hours_cubit.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/ui/widgets/profile_working_hours_items_widget.dart';

class WorkingHoursListWidget extends StatelessWidget {
  final WorkingHoursCubit cubit;
  final List<WorkingHoursModel> items;

  const WorkingHoursListWidget({
    super.key,
    required this.cubit,
    required this.items,
  });

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
              isExpanded: cubit.expandedWorkingHourUuid == item.expandKey,
              showDivider: index != items.length - 1,
              onTap: () => cubit.toggleWorkingHour(item.expandKey),
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
