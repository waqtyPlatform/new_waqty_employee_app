import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/logic/report_bug_cubit.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/ui/widgets/report_bug_app_info_widget.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/ui/widgets/report_bug_category_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_text_area_widget.dart';

class ReportBugBodyWidget extends StatelessWidget {
  const ReportBugBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = ReportBugCubit.get(context);
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
