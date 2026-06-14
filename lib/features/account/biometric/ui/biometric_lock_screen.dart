import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/logic/app_pin_cubit.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/logic/app_pin_state.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/app_pin_button_widget.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/app_pin_header_widget.dart';

class BiometricLockScreen extends StatefulWidget {
  const BiometricLockScreen({super.key});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen> {
  bool _didPrompt = false;
  bool _didNavigate = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _didPrompt) return;
      _didPrompt = true;
      AppPinCubit.get(context).authenticateWithBiometric();
    });
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
              return current is BiometricCheckingState ||
                  current is BiometricAuthFailureState ||
                  current is BiometricNotEnrolledState ||
                  current is BiometricNotSupportedState ||
                  current is AppPinForceLogoutState;
            },
            builder: (context, state) {
              final cubit = AppPinCubit.get(context);
              final isLoading = state is BiometricCheckingState;
              final canUsePin = cubit.isPinEnabled;
              final showSettings =
                  state is BiometricNotEnrolledState ||
                  state is BiometricNotSupportedState ||
                  state is BiometricAuthFailureState;

              return Column(
                children: [
                  AppPinHeaderWidget(
                    title: context.tr('biometricLogin.lockTitle'),
                    canPop: false,
                  ),
                  const Spacer(),
                  Container(
                    width: 96.r,
                    height: 96.r,
                    decoration: BoxDecoration(
                      color: AppColors.greenColor505,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.fingerprint,
                      size: 56.r,
                      color: AppColors.greenColor500,
                    ),
                  ),
                  verticalSpace(20),
                  Text(
                    context.tr('biometricLogin.lockSubtitle'),
                    textAlign: TextAlign.center,
                    style: TextStyles.font16greyColor900Weight600,
                  ),
                  verticalSpace(8),
                  Text(
                    context.tr(cubit.biometricStatusKey),
                    textAlign: TextAlign.center,
                    style: TextStyles.font12greyColor500W500,
                  ),
                  verticalSpace(28),
                  AppPinButtonWidget(
                    text: context.tr('biometricLogin.useBiometric'),
                    isLoading: isLoading,
                    onTap: () => cubit.authenticateWithBiometric(),
                  ),
                  verticalSpace(10),
                  AppPinButtonWidget(
                    text: context.tr('biometricLogin.retry'),
                    backgroundColor: AppColors.whiteColor,
                    textColor: AppColors.greenColor500,
                    borderColor: AppColors.greenColor500,
                    onTap: () => cubit.authenticateWithBiometric(),
                  ),
                  if (canUsePin) ...[
                    verticalSpace(10),
                    AppPinButtonWidget(
                      text: context.tr('biometricLogin.usePinInstead'),
                      backgroundColor: AppColors.greyColorFA,
                      textColor: AppColors.greyColor900,
                      onTap: () => cubit.goToPinFallback(),
                    ),
                  ],
                  if (showSettings) ...[
                    verticalSpace(10),
                    AppPinButtonWidget(
                      text: context.tr('biometricLogin.openSettings'),
                      backgroundColor: AppColors.greyColorFA,
                      textColor: AppColors.greyColor900,
                      onTap: () => cubit.openSecuritySettings(),
                    ),
                  ],
                  verticalSpace(10),
                  AppPinButtonWidget(
                    text: context.tr('logout.logout'),
                    backgroundColor: AppColors.whiteColor,
                    textColor: AppColors.errorColor2002,
                    borderColor: AppColors.greyColorE5,
                    onTap: () => cubit.logoutFromLockScreen(),
                  ),
                  const Spacer(flex: 2),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context, AppPinState state) {
    if (state is BiometricAuthSuccessState) {
      if (_didNavigate) return;
      _didNavigate = true;
      context.pushNamedAndRemoveUntil(
        Routes.mainNavigationScreen,
        arguments: {'securityVerified': true, 'pinVerified': true},
        predicate: (route) => false,
      );
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
    } else if (state is PinRequiredState) {
      if (_didNavigate) return;
      _didNavigate = true;
      context.pushNamed(Routes.enterAppPinScreen);
    } else if (state is AppPinForceLogoutState) {
      if (_didNavigate) return;
      _didNavigate = true;
      context.pushNamedAndRemoveUntil(
        Routes.loginScreen,
        predicate: (route) => false,
      );
    }
  }
}
