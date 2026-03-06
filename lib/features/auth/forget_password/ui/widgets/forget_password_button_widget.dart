import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/services/check_network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/button_widget.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/logic/forget_password_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/logic/forget_password_state.dart';

class ForgetPasswordButtonWidget extends StatelessWidget {
  const ForgetPasswordButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      buildWhen: (previous, current) {
        return current is ForgetPasswordLoadingState ||
            current is ForgetPasswordSuccessState ||
            current is ForgetPasswordErrorState ||
            current is ForgetPasswordCatchErrorState;
      },
      listener: (context, state) {
        if (state is ForgetPasswordSuccessState) {
          AppConstant.toast(
            context.tr('forgetPassword.successMessage'),
            true,
            context,
          );
          Navigator.pushNamed(
            context,
            Routes.verifyCodeScreen,
            arguments: {
              'email': ForgetPasswordCubit.get(context).emailController.text,
            },
          );
        } else if (state is ForgetPasswordErrorState) {
          AppConstant.toast(state.message, false, context);
        } else if (state is ForgetPasswordCatchErrorState) {
          AppConstant.toast(
            context.tr('forgetPassword.errorMessage'),
            false,
            context,
          );
        }
      },
      builder: (context, state) {
        return ButtonWidget(
          isLoading: state is ForgetPasswordLoadingState,
          borderRadius: 12,
          buttonHeight: 50.h,
          buttonText: context.tr('forgetPassword.sendOtp'),
          backGroundColor: AppColors.greenColor500,
          borderColor: AppColors.greenColor500,
          textStyle: TextStyles.font16whiteColorWeight600,
          onPressed: () {
            validateForgetPassword(context);
          },
        );
      },
    );
  }

  void validateForgetPassword(BuildContext context) {
    if (ForgetPasswordCubit.get(
      context,
    ).forgetPasswordKey.currentState!.validate()) {
      if (MyConnectivity.isOnline()) {
        ForgetPasswordCubit.get(context).forgetPassword();
      } else {
        AppConstant.toast(
          context.tr('forgetPassword.noInternet'),
          false,
          context,
        );
      }
    }
  }
}
