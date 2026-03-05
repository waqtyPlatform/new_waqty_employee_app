import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/assets_manager.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/button_widget.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/logic/reset_password_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/logic/reset_password_state.dart';

class ResetPasswordButtonWidget extends StatelessWidget {
  const ResetPasswordButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
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
          buttonText: 'Create New Password',
          backGroundColor: AppColors.greenColor500,
          borderColor: AppColors.greenColor500,
          textStyle: TextStyles.font16whiteColorWeight600,
          onPressed: () {
            showDialogChangePasswordDone(context);
          },
        );
      },
    );
  }

  static showDialogChangePasswordDone(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.greyColor3004.withValues(alpha: .4),
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.whiteColor,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(child: Image.asset(ImageAsset.doneImage)),
              verticalSpace(24),
              Text(
                'Password Changes!',
                style: TextStyles.font18greyColor900Weight600,
                textAlign: TextAlign.center,
              ),
              verticalSpace(8),
              Text(
                'Password has been changed successfully',
                textAlign: TextAlign.center,
                style: TextStyles.font14greyColor4002Weight400,
              ),
              verticalSpace(24),
              ButtonWidget(
                isLoading: false,
                borderRadius: 12,
                buttonHeight: 50.h,
                buttonText: 'Login Now',
                backGroundColor: AppColors.greenColor500,
                borderColor: AppColors.greenColor500,
                textStyle: TextStyles.font16whiteColorWeight600,
                onPressed: () {
                  context.pushNamedAndRemoveUntil(
                    Routes.loginScreen,
                    predicate: (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
