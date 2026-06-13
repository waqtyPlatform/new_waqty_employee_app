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

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({super.key});

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final PageController _pageController = PageController();
  int _currentStepIndex = 0;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    _pageController.dispose();
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
                children: [
                  AppPinHeaderWidget(title: context.tr('appPin.changeTitle')),
                  verticalSpace(16),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() => _currentStepIndex = index);
                      },
                      children: [
                        ChangePinFlowStepWidget(
                          data: ChangePinStepData.fromStep(
                            ChangePinStep.newPin,
                          ),
                          controller: _pinController,
                          autofocus: _currentStepIndex == 0,
                          onCompleted: () => _animateToStep(1),
                        ),
                        ChangePinFlowStepWidget(
                          data: ChangePinStepData.fromStep(
                            ChangePinStep.confirmPin,
                          ),
                          controller: _confirmPinController,
                          autofocus: _currentStepIndex == 1,
                          onCompleted: () {
                            AppPinCubit.get(context).enablePin(
                              pin: _pinController.text,
                              confirmPin: _confirmPinController.text,
                            );
                          },
                        ),
                      ],
                    ),
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
      AppConstant.toast(context.tr(state.messageKey), false, context);
    }
  }

  void _animateToStep(int step) {
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }
}
