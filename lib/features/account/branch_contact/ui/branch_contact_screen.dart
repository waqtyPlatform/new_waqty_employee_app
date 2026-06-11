import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/ui/widgets/branch_contact_body_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_header_widget.dart';

class BranchContactScreen extends StatelessWidget {
  const BranchContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            AccountSupportHeaderWidget(titleKey: 'branchContact.title'),
            Expanded(child: BranchContactBodyWidget()),
          ],
        ),
      ),
    );
  }
}
