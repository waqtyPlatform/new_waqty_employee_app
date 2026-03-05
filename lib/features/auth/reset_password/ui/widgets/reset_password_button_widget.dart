import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/assets_manager.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/button_widget.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/logic/reset_password_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/logic/reset_password_state.dart';

class ResetPasswordButtonWidget extends StatelessWidget {
  final String email;
  final String code;
  const ResetPasswordButtonWidget({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      buildWhen: (previous, current) {
        return current is ResetPasswordLoadingState ||
            current is ResetPasswordSuccessState ||
            current is ResetPasswordErrorState ||
            current is ResetPasswordCatchErrorState;
      },
      listener: (context, state) {
        if (state is ResetPasswordSuccessState) {
          AppConstant.toast('Password Changed Successfully', true, context);
          showDialogChangePasswordDone(context);
        } else if (state is ResetPasswordErrorState) {
          AppConstant.toast(state.message, false, context);
        } else if (state is ResetPasswordCatchErrorState) {
          AppConstant.toast('Something went wrong', false, context);
        }
      },
      builder: (context, state) {
        return ButtonWidget(
          isLoading: state is ResetPasswordLoadingState,
          borderRadius: 12,
          buttonHeight: 50.h,
          buttonText: 'Create New Password',
          backGroundColor: AppColors.greenColor500,
          borderColor: AppColors.greenColor500,
          textStyle: TextStyles.font16whiteColorWeight600,
          onPressed: () {
            validateResetPassword(email, code, context);
          },
        );
      },
    );
  }

  void validateResetPassword(String email, String code, BuildContext context) {
    if (ResetPasswordCubit.get(
      context,
    ).resetPasswordKey.currentState!.validate()) {
      ResetPasswordCubit.get(context).resetPassword(email, code);
    }
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
