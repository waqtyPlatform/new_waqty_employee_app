import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/change_pin_header_widget.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/change_pin_info_card_widget.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/change_pin_progress_widget.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/change_pin_step_data.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/change_pin_step_pin_card_widget.dart';

class ChangePinScreen extends StatelessWidget {
  final ChangePinStep step;

  const ChangePinScreen({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    final data = ChangePinStepData.fromStep(step);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ChangePinHeaderWidget(),
              verticalSpace(16),
              ChangePinInfoCardWidget(data: data),
              verticalSpace(12),
              ChangePinProgressWidget(activeStep: data.stepIndex),
              verticalSpace(12),
              ChangePinStepPinCardWidget(data: data),
            ],
          ),
        ),
      ),
    );
  }
}
