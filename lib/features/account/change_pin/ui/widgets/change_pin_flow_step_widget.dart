import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/app_pin_code_field_widget.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/change_pin_info_card_widget.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/change_pin_progress_widget.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/change_pin_step_data.dart';

class ChangePinFlowStepWidget extends StatelessWidget {
  final ChangePinStepData data;
  final TextEditingController controller;
  final bool autofocus;
  final VoidCallback onCompleted;

  const ChangePinFlowStepWidget({
    super.key,
    required this.data,
    required this.controller,
    required this.onCompleted,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChangePinInfoCardWidget(data: data),
        verticalSpace(12),
        ChangePinProgressWidget(activeStep: data.stepIndex),
        verticalSpace(12),
        AppPinCodeFieldWidget(
          controller: controller,
          hintKey: data.hintKey,
          autofocus: autofocus,
          onCompleted: onCompleted,
        ),
      ],
    );
  }
}
