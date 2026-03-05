import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/button_widget.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/logic/verify_code_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/logic/verify_code_state.dart';

class VerifyCodeButtonWidget extends StatelessWidget {
  const VerifyCodeButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyCodeCubit, VerifyCodeState>(
      // buildWhen: (previous, current) {
      //   return current is OnLoginLoadingState ||
      //       current is OnLoginSuccessState ||
      //       current is OnLoginErrorState ||
      //       current is OnLoginCatchErrorState;
      // },
      listener: (context, state) {
        // if (state is OnLoginSuccessState) {
        //   AppConstant.toast('Login successfully', true, context);
        //   if (type == 'sender') {
        //     context.pushNamed(Routes.senderButtonNavigationBarScreen);
        //   } else {
        //     context.pushNamed(Routes.buttonNavigationBarScreen);
        //   }
        //
        //   ///
        // } else if (state is OnLoginErrorState) {
        //   AppConstant.toast(state.message, false, context);
        // } else if (state is OnLoginCatchErrorState) {
        //   AppConstant.toast('Email Or Password is Wrong', false, context);
        // }
      },
      builder: (context, state) {
        return ButtonWidget(
          isLoading: false,
          borderRadius: 12,
          buttonHeight: 50.h,
          buttonText: "Verify Code",
          backGroundColor: AppColors.greenColor500,
          borderColor: AppColors.greenColor500,
          textStyle: TextStyles.font16whiteColorWeight600,
          onPressed: () {
            context.pushNamed(Routes.resetPasswordScreen);
          },
        );
      },
    );
  }
}
