import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/button_widget.dart';
import 'package:new_waqty_employee_app/features/auth/login/logic/login_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/login/logic/login_state.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';

class LoginButtonWidget extends StatelessWidget {
  const LoginButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      buildWhen: (previous, current) {
        return current is OnLoginLoadingState ||
            current is OnLoginSuccessState ||
            current is OnLoginErrorState ||
            current is OnLoginCatchErrorState;
      },
      listener: (context, state) {
        if (state is OnLoginSuccessState) {
          AppConstant.toast('Login successfully', true, context);
          // context.pushNamed(
          // Routes.homeScreen,
          // ); // Assuming home screen is the destination
        } else if (state is OnLoginErrorState) {
          AppConstant.toast(state.message, false, context);
        } else if (state is OnLoginCatchErrorState) {
          AppConstant.toast('Email Or Password is Wrong', false, context);
        }
      },
      builder: (context, state) {
        return ButtonWidget(
          isLoading: state is OnLoginLoadingState,
          borderRadius: 12,
          buttonHeight: 50.h,
          buttonText: 'Sign In',
          backGroundColor: AppColors.greenColor500,
          borderColor: AppColors.greenColor500,
          fourGroundColor: AppColors.whiteColor,
          textStyle: TextStyles.font16whiteColorWeight600,
          onPressed: () {
            validatelogin(context);
            // context.pushNamed(Routes.buttonNavigationBarScreen);
          },
        );
      },
    );
  }

  void validatelogin(BuildContext context) {
    if (LoginCubit.get(context).loginKey.currentState!.validate()) {
      LoginCubit.get(context).login();
    }
  }
}
