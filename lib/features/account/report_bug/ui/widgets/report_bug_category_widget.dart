import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/logic/report_bug_cubit.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/logic/report_bug_state.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_chip_widget.dart';

class ReportBugCategoryWidget extends StatelessWidget {
  const ReportBugCategoryWidget({super.key});

  static const List<_ReportBugCategoryData> _categories = [
    _ReportBugCategoryData(
      key: 'reportBug.appointments',
      value: 'appointments',
    ),
    _ReportBugCategoryData(key: 'reportBug.schedule', value: 'schedule'),
    _ReportBugCategoryData(key: 'reportBug.earnings', value: 'earnings'),
    _ReportBugCategoryData(key: 'reportBug.clockInOut', value: 'clock_in_out'),
    _ReportBugCategoryData(
      key: 'reportBug.notifications',
      value: 'notifications',
    ),
    _ReportBugCategoryData(key: 'reportBug.other', value: 'other'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportBugCubit, ReportBugState>(
      buildWhen: (previous, current) =>
          current is ReportBugCategoryChangedState,
      builder: (context, state) {
        final cubit = ReportBugCubit.get(context);
        return AccountSupportCardWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('reportBug.category'),
                style: TextStyles.font14greyColor900Weight600,
              ),
              verticalSpace(12),
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: _categories
                    .map(
                      (category) => AccountSupportChipWidget(
                        text: context.tr(category.key),
                        isSelected: cubit.selectedCategoryKey == category.key,
                        onTap: () => cubit.changeCategory(
                          category: category.value,
                          categoryKey: category.key,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ReportBugCategoryData {
  final String key;
  final String value;

  const _ReportBugCategoryData({required this.key, required this.value});
}
