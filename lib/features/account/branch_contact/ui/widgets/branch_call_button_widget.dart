import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_primary_button_widget.dart';

class BranchCallButtonWidget extends StatelessWidget {
  final String? phone;

  const BranchCallButtonWidget({super.key, this.phone});

  @override
  Widget build(BuildContext context) {
    final hasPhone = phone?.trim().isNotEmpty == true;
    return AccountSupportPrimaryButtonWidget(
      textKey: 'branchContact.callBranch',
      icon: Icons.phone_outlined,
      padding: EdgeInsets.zero,
      onTap: hasPhone
          ? () {
              AppConstant.openPhoneCall(phone!);
            }
          : null,
    );
  }
}
