import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/logic/contact_manager_cubit.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/logic/contact_manager_state.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_chip_widget.dart';

class ContactManagerSubjectWidget extends StatelessWidget {
  const ContactManagerSubjectWidget({super.key});

  static const List<_ContactSubjectData> _subjects = [
    _ContactSubjectData(
      key: 'contactManager.scheduleIssue',
      value: 'Schedule question',
    ),
    _ContactSubjectData(
      key: 'contactManager.payrollQuery',
      value: 'Payroll query',
    ),
    _ContactSubjectData(
      key: 'contactManager.performanceReview',
      value: 'Performance review',
    ),
    _ContactSubjectData(
      key: 'contactManager.generalInquiry',
      value: 'General inquiry',
    ),
    _ContactSubjectData(key: 'contactManager.other', value: 'Other'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactManagerCubit, ContactManagerState>(
      buildWhen: (previous, current) =>
          current is ContactManagerSubjectChangedState,
      builder: (context, state) {
        final cubit = ContactManagerCubit.get(context);
        return AccountSupportCardWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('contactManager.subject'),
                style: TextStyles.font14greyColor900Weight600,
              ),
              verticalSpace(12),
              Wrap(
                spacing: 6.w,
                runSpacing: 6.h,
                children: _subjects
                    .map(
                      (subject) => AccountSupportChipWidget(
                        text: context.tr(subject.key),
                        isSelected: cubit.selectedSubjectKey == subject.key,
                        onTap: () => cubit.changeSubject(
                          subject: subject.value,
                          subjectKey: subject.key,
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

class _ContactSubjectData {
  final String key;
  final String value;

  const _ContactSubjectData({required this.key, required this.value});
}
