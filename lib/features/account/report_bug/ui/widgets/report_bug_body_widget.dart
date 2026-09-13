import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/logic/report_bug_cubit.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/logic/report_bug_state.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/ui/widgets/report_bug_app_info_widget.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/ui/widgets/report_bug_category_widget.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/ui/widgets/report_bug_list_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_text_area_widget.dart';

class ReportBugBodyWidget extends StatelessWidget {
  const ReportBugBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBugCubit, ReportBugState>(
      buildWhen: (previous, current) =>
          current is ReportBugViewChangedState ||
          current is ReportBugListLoadingState ||
          current is ReportBugListSuccessState ||
          current is ReportBugListErrorState ||
          current is ReportBugListPaginationLoadingState ||
          current is ReportBugListPaginationSuccessState,
      builder: (context, state) {
        final cubit = ReportBugCubit.get(context);
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
              child: _ReportBugViewSwitch(cubit: cubit),
            ),
            Expanded(
              child: cubit.showReports
                  ? const ReportBugListWidget()
                  : _ReportBugFormWidget(cubit: cubit),
            ),
          ],
        );
      },
    );
  }
}

class _ReportBugFormWidget extends StatelessWidget {
  final ReportBugCubit cubit;

  const _ReportBugFormWidget({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      child: Column(
        children: [
          const ReportBugCategoryWidget(),
          verticalSpace(12),
          AccountSupportTextAreaWidget(
            titleKey: 'reportBug.describeIssue',
            subtitleKey: 'reportBug.describeIssueHint',
            hintKey: 'reportBug.describePlaceholder',
            showCounter: true,
            controller: cubit.descriptionController,
          ),
          verticalSpace(12),
          AccountSupportTextAreaWidget(
            titleKey: 'reportBug.stepsToReproduce',
            subtitleKey: 'reportBug.stepsHint',
            hintKey: 'reportBug.stepsPlaceholder',
            isOptional: true,
            controller: cubit.stepsController,
          ),
          verticalSpace(12),
          const ReportBugAppInfoWidget(),
        ],
      ),
    );
  }
}

class _ReportBugViewSwitch extends StatelessWidget {
  final ReportBugCubit cubit;

  const _ReportBugViewSwitch({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SwitchButton(
            title: context.tr('reportBug.newReport'),
            isSelected: !cubit.showReports,
            onTap: () => cubit.changeView(false),
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _SwitchButton(
            title: context.tr('reportBug.myReports'),
            isSelected: cubit.showReports,
            onTap: () => cubit.changeView(true),
          ),
        ),
      ],
    );
  }
}

class _SwitchButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SwitchButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100.r),
      child: Container(
        height: 40.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.greenColor500 : AppColors.greyColorFA,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: isSelected ? AppColors.greenColor500 : AppColors.greyColorF5,
            width: .8.w,
          ),
        ),
        child: Text(
          title,
          style: TextStyles.font12greyColor900Weight600.copyWith(
            color: isSelected ? AppColors.whiteColor : AppColors.greyColor500,
          ),
        ),
      ),
    );
  }
}
