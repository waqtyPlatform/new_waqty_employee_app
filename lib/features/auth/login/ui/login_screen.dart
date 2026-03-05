import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/assets_manager.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/auth/login/logic/login_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/login/ui/widgets/login_button_widget.dart';
import 'package:new_waqty_employee_app/features/auth/login/ui/widgets/login_email_widget.dart';
import 'package:new_waqty_employee_app/features/auth/login/ui/widgets/login_password_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: LoginCubit.get(context).loginKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(16),
                Text(
                  'Welcome Back! 👋',
                  style: TextStyles.font24greyColor900Weight600,
                ),
                verticalSpace(6),
                Text(
                  'Sign in with your employee credentials to access the system.',
                  style: TextStyles.font14greyColor4002Weight400,
                ),

                verticalSpace(16),
                Text('Email', style: TextStyles.font14greyColor900Weight500),
                verticalSpace(6),
                const LoginEmailWidget(),
                verticalSpace(16),

                Text('Password', style: TextStyles.font14greyColor900Weight500),
                verticalSpace(6),
                const LoginPasswordWidget(),
                verticalSpace(16),
                Align(
                  alignment: AlignmentGeometry.centerEnd,
                  child: GestureDetector(
                    onTap: () {
                      context.pushNamed(Routes.forgetPasswordScreen);
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyles.font14greenColor500Weight600.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.greenColor500.withOpacity(
                          0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                verticalSpace(48),
                const LoginButtonWidget(),
                verticalSpace(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
