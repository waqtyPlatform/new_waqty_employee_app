import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/logic/contact_manager_cubit.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/ui/widgets/contact_manager_priority_widget.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/ui/widgets/contact_manager_subject_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_text_area_widget.dart';

class ContactManagerBodyWidget extends StatelessWidget {
  const ContactManagerBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = ContactManagerCubit.get(context);
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
      child: Column(
        children: [
          const ContactManagerSubjectWidget(),
          verticalSpace(12),
          AccountSupportTextAreaWidget(
            titleKey: 'contactManager.message',
            hintKey: 'contactManager.messagePlaceholder',
            showCounter: true,
            controller: cubit.messageController,
          ),
          verticalSpace(12),
          const ContactManagerPriorityWidget(),
        ],
      ),
    );
  }
}
