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
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/app_pin_button_widget.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/app_pin_code_field_widget.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/app_pin_header_widget.dart';

class EnableBiometricScreen extends StatefulWidget {
  const EnableBiometricScreen({super.key});

  @override
  State<EnableBiometricScreen> createState() => _EnableBiometricScreenState();
}

class _EnableBiometricScreenState extends State<EnableBiometricScreen> {
  final TextEditingController _currentPinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cubit = AppPinCubit.get(context);
      await cubit.loadSecuritySettings();
      if (mounted && !cubit.isPinEnabled) {
        await cubit.enableBiometric();
      }
    });
  }

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
            buildWhen: (previous, current) {
              return current is AppPinLoadingState ||
                  current is AppPinStatusChangedState ||
                  current is BiometricCheckingState ||
                  current is AppPinErrorState ||
                  current is BiometricAuthFailureState ||
                  current is BiometricNotEnrolledState ||
                  current is BiometricNotSupportedState;
            },
            builder: (context, state) {
              final cubit = AppPinCubit.get(context);
              final isLoading =
                  state is AppPinLoadingState ||
                  state is BiometricCheckingState;
              final showSettings =
                  state is BiometricNotEnrolledState ||
                  state is BiometricNotSupportedState;

              if (!cubit.isPinEnabled) {
                return _BiometricDirectActionView(
                  isLoading: isLoading,
                  showSettings: showSettings,
                  onUseBiometric: () => cubit.enableBiometric(),
                  onOpenSettings: () => cubit.openSecuritySettings(),
                );
              }

              return Column(
                children: [
                  AppPinHeaderWidget(
                    title: context.tr('profile.biometricLogin'),
                  ),
                  verticalSpace(34),
                  _BiometricPinConfirmHeroWidget(
                    icon: Icons.fingerprint,
                    iconColor: AppColors.greenColor500,
                    backgroundColor: AppColors.greenColor5005,
                    titleKey: 'biometricLogin.confirmPinTitle',
                    subtitleKey: 'biometricLogin.confirmEnablePinSubtitle',
                  ),
                  verticalSpace(18),
                  _BiometricPinInputCardWidget(
                    controller: _currentPinController,
                    onCompleted: () => cubit.enableBiometric(
                      currentPin: _currentPinController.text,
                    ),
                  ),
                  if (showSettings) ...[
                    verticalSpace(14),
                    AppPinButtonWidget(
                      text: context.tr('biometricLogin.openSettings'),
                      backgroundColor: AppColors.greyColorFA,
                      textColor: AppColors.greyColor900,
                      borderColor: AppColors.greyColorE5,
                      onTap: () => cubit.openSecuritySettings(),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context, AppPinState state) {
    if (state is BiometricEnabledState) {
      AppConstant.toast(
        context.tr('biometricLogin.enabledSuccess'),
        true,
        context,
      );
      Navigator.maybePop(context);
    } else if (state is AppPinErrorState) {
      _currentPinController.clear();
      AppConstant.toast(context.tr(state.messageKey), false, context);
    } else if (state is BiometricAuthFailureState) {
      AppConstant.toast(context.tr(state.messageKey), false, context);
    } else if (state is BiometricNotEnrolledState) {
      AppConstant.toast(
        context.tr('biometricLogin.notEnrolledMessage'),
        false,
        context,
      );
    } else if (state is BiometricNotSupportedState) {
      AppConstant.toast(
        context.tr('biometricLogin.notSupportedMessage'),
        false,
        context,
      );
    }
  }
}

class _BiometricDirectActionView extends StatelessWidget {
  final bool isLoading;
  final bool showSettings;
  final VoidCallback onUseBiometric;
  final VoidCallback onOpenSettings;

  const _BiometricDirectActionView({
    required this.isLoading,
    required this.showSettings,
    required this.onUseBiometric,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppPinHeaderWidget(title: context.tr('profile.biometricLogin')),
        const Spacer(),
        Icon(Icons.fingerprint, size: 96.r, color: AppColors.greenColor500),
        verticalSpace(18),
        Text(
          context.tr('biometricLogin.scanningTitle'),
          textAlign: TextAlign.center,
          style: TextStyles.font16greyColor900Weight600,
        ),
        verticalSpace(6),
        Text(
          context.tr('biometricLogin.scanningSubtitle'),
          textAlign: TextAlign.center,
          style: TextStyles.font14greyColorA3W400,
        ),
        verticalSpace(24),
        AppPinButtonWidget(
          text: context.tr('biometricLogin.useBiometric'),
          isLoading: isLoading,
          onTap: onUseBiometric,
        ),
        if (showSettings) ...[
          verticalSpace(10),
          AppPinButtonWidget(
            text: context.tr('biometricLogin.openSettings'),
            backgroundColor: AppColors.greyColorFA,
            textColor: AppColors.greyColor900,
            borderColor: AppColors.greyColorE5,
            onTap: onOpenSettings,
          ),
        ],
        const Spacer(flex: 2),
      ],
    );
  }
}

class _BiometricPinConfirmHeroWidget extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String titleKey;
  final String subtitleKey;

  const _BiometricPinConfirmHeroWidget({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.titleKey,
    required this.subtitleKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 44.r,
          backgroundColor: backgroundColor,
          child: Icon(icon, color: iconColor, size: 44.r),
        ),
        verticalSpace(34),
        Text(
          context.tr(titleKey),
          textAlign: TextAlign.center,
          style: TextStyles.font18greyColor900Weight600,
        ),
        verticalSpace(4),
        Text(
          context.tr(subtitleKey),
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
