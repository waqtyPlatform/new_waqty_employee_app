import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/logic/reset_password_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/ui/widgets/reset_password_new_password_widget.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/ui/widgets/reset_password_confirm_password_widget.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/ui/widgets/reset_password_button_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  final String code;
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.arrow_back, color: AppColors.greyColor900),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: ResetPasswordCubit.get(context).resetPasswordKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(16),
                Text(
                  'Reset Password 🔑',
                  style: TextStyles.font24greyColor900Weight600,
                ),
                verticalSpace(6),
                Text(
                  'Create a new password for your account.',
                  style: TextStyles.font14greyColor4002Weight400,
                ),
                verticalSpace(24),
                Text(
                  'New Password',
                  style: TextStyles.font14greyColor900Weight500,
                ),
                verticalSpace(6),
                const ResetPasswordNewPasswordWidget(),
                verticalSpace(16),
                Text(
                  'Confirm Password',
                  style: TextStyles.font14greyColor900Weight500,
                ),
                verticalSpace(6),
                const ResetPasswordConfirmPasswordWidget(),
                verticalSpace(48),
                ResetPasswordButtonWidget(email: email, code: code),
                verticalSpace(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
