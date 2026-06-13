import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/logic/app_pin_cubit.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/logic/app_pin_state.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/app_pin_header_widget.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/change_pin_flow_step_widget.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/change_pin_step_data.dart';

class DisableAppPinScreen extends StatefulWidget {
  const DisableAppPinScreen({super.key});

  @override
  State<DisableAppPinScreen> createState() => _DisableAppPinScreenState();
}

class _DisableAppPinScreenState extends State<DisableAppPinScreen> {
  final TextEditingController _currentPinController = TextEditingController();

  @override
  void dispose() {
    _currentPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: BlocConsumer<AppPinCubit, AppPinState>(
            listener: _listener,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppPinHeaderWidget(title: context.tr('appPin.disableAppPin')),
                  verticalSpace(16),
                  ChangePinFlowStepWidget(
                    data: ChangePinStepData.fromStep(ChangePinStep.currentPin),
                    controller: _currentPinController,
                    autofocus: true,
                    onCompleted: () {
                      AppPinCubit.get(
                        context,
                      ).disablePin(_currentPinController.text);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context, AppPinState state) {
    if (state is AppPinSuccessState) {
      AppConstant.toast(context.tr(state.messageKey), true, context);
      Navigator.maybePop(context);
    } else if (state is AppPinErrorState) {
      _currentPinController.clear();
      AppConstant.toast(context.tr(state.messageKey), false, context);
    }
  }
}
