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
import 'package:new_waqty_employee_app/features/auth/verify_code/logic/verify_code_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/logic/verify_code_state.dart';

class VerifyCodeButtonWidget extends StatelessWidget {
  final String email;
  const VerifyCodeButtonWidget({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyCodeCubit, VerifyCodeState>(
      buildWhen: (previous, current) {
        return current is VerifyCodeLoadingState ||
            current is VerifyCodeSuccessState ||
            current is VerifyCodeErrorState ||
            current is VerifyCodeCatchErrorState;
      },
      listener: (context, state) {
        if (state is VerifyCodeSuccessState) {
          AppConstant.toast(
            context.tr('verifyCode.successMessage'),
            true,
            context,
          );
          context.pushNamed(
            Routes.resetPasswordScreen,
            arguments: {
              'email': email,
              'code': VerifyCodeCubit.get(context).codeController.text,
            },
          ); // Assuming home screen is the destination
        } else if (state is VerifyCodeErrorState) {
          AppConstant.toast(state.message, false, context);
        } else if (state is VerifyCodeCatchErrorState) {
          AppConstant.toast(
            context.tr('verifyCode.errorMessage'),
            false,
            context,
          );
        }
      },
      builder: (context, state) {
        return ButtonWidget(
          isLoading: state is VerifyCodeLoadingState,
          borderRadius: 12,
          buttonHeight: 50.h,
          buttonText: context.tr('verifyCode.verify'),
          backGroundColor: AppColors.greenColor500,
          borderColor: AppColors.greenColor500,
          textStyle: TextStyles.font16whiteColorWeight600,
          onPressed: () {
            validateVerifyCode(context);
          },
        );
      },
    );
  }

  void validateVerifyCode(BuildContext context) {
    final code = VerifyCodeCubit.get(context).codeController.text;
    if (code.length != 4) {
      AppConstant.toast(context.tr('verifyCode.codeError'), false, context);
      return;
    }
    if (VerifyCodeCubit.get(context).verifyCodeKey.currentState!.validate()) {
      if (MyConnectivity.isOnline()) {
        VerifyCodeCubit.get(context).verifyCode(email);
      } else {
        AppConstant.toast(context.tr('verifyCode.noInternet'), false, context);
      }
    }
  }
}
