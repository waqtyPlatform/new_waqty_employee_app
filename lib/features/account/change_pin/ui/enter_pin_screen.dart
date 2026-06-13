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
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/app_pin_code_field_widget.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/app_pin_header_widget.dart';

class EnterPinScreen extends StatefulWidget {
  const EnterPinScreen({super.key});

  @override
  State<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends State<EnterPinScreen> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
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
              final cubit = AppPinCubit.get(context);
              final isLoading = state is AppPinLoadingState;
              final isLocked = state is AppPinLockedState;

              return Column(
                children: [
                  AppPinHeaderWidget(
                    title: context.tr('appPin.enterTitle'),
                    canPop: false,
                  ),
                  const Spacer(),
                  Icon(
                    Icons.lock_outline,
                    size: 72.r,
                    color: AppColors.greenColor500,
                  ),
                  verticalSpace(20),
                  AppPinCodeFieldWidget(
                    controller: _pinController,
                    hintKey: 'appPin.enterPinHint',
                  ),
                  if (isLocked) ...[
                    verticalSpace(10),
                    Text(
                      context.tr(
                        'appPin.lockedMessage',
                        namedArgs: {
                          'seconds': cubit.remainingLockSeconds.toString(),
                        },
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyles.font12warningColor1001Weight500,
                    ),
                  ],
                  verticalSpace(16),
                  AppPinButtonWidget(
                    text: context.tr('appPin.unlock'),
                    isLoading: isLoading,
                    onTap: isLocked
                        ? null
                        : () => cubit.verifyPin(_pinController.text),
                  ),
                  verticalSpace(12),
                  TextButton(
                    onPressed: () => _showForgotPinDialog(context),
                    child: Text(
                      context.tr('appPin.forgotPin'),
                      style: TextStyles.font14greenColor500Weight600,
                    ),
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
    if (state is AppPinVerifiedState) {
      context.pushNamedAndRemoveUntil(
        Routes.mainNavigationScreen,
        arguments: {'pinVerified': true},
        predicate: (route) => false,
      );
    } else if (state is AppPinErrorState) {
      AppConstant.toast(context.tr(state.messageKey), false, context);
    } else if (state is AppPinForceLogoutState) {
      context.pushNamedAndRemoveUntil(
        Routes.loginScreen,
        predicate: (route) => false,
      );
    }
  }

  void _showForgotPinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.whiteColor,
        title: Text(
          context.tr('appPin.forgotPin'),
          style: TextStyles.font18greyColor900Weight600,
        ),
        content: Text(
          context.tr('appPin.forgotPinMessage'),
          style: TextStyles.font14greyColor500W400,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              context.tr('appPin.cancel'),
              style: TextStyles.font14greyColor500W500,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              AppPinCubit.get(context).forgotPin();
            },
            child: Text(
              context.tr('appPin.confirm'),
              style: TextStyles.font14errorColor2002W500,
            ),
          ),
        ],
      ),
    );
  }
}
