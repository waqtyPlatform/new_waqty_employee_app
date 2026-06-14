import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/logic/app_pin_cubit.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/logic/app_pin_state.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/app_pin_code_field_widget.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/app_pin_header_widget.dart';

class DisableBiometricScreen extends StatefulWidget {
  const DisableBiometricScreen({super.key});

  @override
  State<DisableBiometricScreen> createState() => _DisableBiometricScreenState();
}

class _DisableBiometricScreenState extends State<DisableBiometricScreen> {
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
                children: [
                  AppPinHeaderWidget(
                    title: context.tr('profile.biometricLogin'),
                  ),
                  verticalSpace(34),
                  const _BiometricPinConfirmHeroWidget(),
                  verticalSpace(18),
                  _BiometricPinInputCardWidget(
                    controller: _currentPinController,
                    onCompleted: () => AppPinCubit.get(
                      context,
                    ).disableBiometric(currentPin: _currentPinController.text),
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
    if (state is BiometricDisabledState) {
      AppConstant.toast(
        context.tr('biometricLogin.disabledSuccess'),
        true,
        context,
      );
      Navigator.maybePop(context);
    } else if (state is AppPinErrorState) {
      _currentPinController.clear();
      AppConstant.toast(context.tr(state.messageKey), false, context);
    }
  }
}

class _BiometricPinConfirmHeroWidget extends StatelessWidget {
  const _BiometricPinConfirmHeroWidget();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 44.r,
          backgroundColor: AppColors.errorColor2003,
          child: Icon(
            Icons.shield_outlined,
            color: AppColors.errorColor2002,
            size: 44.r,
          ),
        ),
        verticalSpace(34),
        Text(
          context.tr('biometricLogin.confirmPinTitle'),
          textAlign: TextAlign.center,
          style: TextStyles.font18greyColor900Weight600,
        ),
        verticalSpace(4),
        Text(
          context.tr('biometricLogin.confirmPinSubtitle'),
          textAlign: TextAlign.center,
          style: TextStyles.font14greyColorA3W400,
        ),
      ],
    );
  }
}

class _BiometricPinInputCardWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onCompleted;

  const _BiometricPinInputCardWidget({
    required this.controller,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return AppPinCodeFieldWidget(
      controller: controller,
      hintKey: 'biometricLogin.pinHint',
      autofocus: true,
      onCompleted: onCompleted,
    );
  }
}
