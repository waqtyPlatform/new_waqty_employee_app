import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/widgets/app_text_field.dart';
import 'package:new_waqty_employee_app/core/widgets/button_widget.dart';
import 'package:new_waqty_employee_app/features/login/logic/login_cubit.dart';
import 'package:new_waqty_employee_app/features/login/logic/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: Form(
            key: LoginCubit.get(context).loginKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(20),
                Text(
                  "Welcome Back! 👋",
                  style: TextStyles.font26BlackColorWeight700.copyWith(
                    fontSize: 28.sp,
                  ),
                ),
                verticalSpace(12),
                Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                  style: TextStyles.font14GreyColor87Weight400.copyWith(
                    color: AppColors.greyColor87,
                    height: 1.5,
                  ),
                ),
                verticalSpace(32),

                // Email Label
                Text(
                  "Email",
                  style: TextStyles.font16BlackColorWeight600.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                verticalSpace(8),
                AppTextFormField(
                  hintText: "aaronramsdale@gmail.com",
                  hintStyle: TextStyles.font14BlackColorWeight400.copyWith(
                    color: AppColors.blackColor50,
                  ),
                  textStyle: TextStyles.font14BlackColorWeight400,
                  controller: LoginCubit.get(context).emailController,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.greyColorDA,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.greenColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.redColor000,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.redColor000,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                verticalSpace(20),

                // Password Label
                Text(
                  "Password",
                  style: TextStyles.font16BlackColorWeight600.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                verticalSpace(8),
                AppTextFormField(
                  hintText: "************",
                  isObscureText: true,
                  hintStyle: TextStyles.font14BlackColorWeight400.copyWith(
                    color: AppColors.blackColor50,
                  ),
                  textStyle: TextStyles.font14BlackColorWeight400,
                  controller: LoginCubit.get(context).passwordController,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.greyColorDA,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.greenColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.redColor000,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.redColor000,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  suffixIcon: Icon(
                    Icons.visibility_outlined,
                    color: AppColors.greyColorA5,
                    size: 20.r,
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                ),

                verticalSpace(12),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Forgot Password?",
                      style: TextStyles.font14greenColor3EWeight600.copyWith(
                        color: const Color(
                          0xff069C54,
                        ), // From the UI it's a bit darker green
                      ),
                    ),
                  ),
                ),

                verticalSpace(32),

                BlocConsumer<LoginCubit, LoginState>(
                  buildWhen: (previous, current) {
                    return current is OnLoginLoadingState ||
                        current is OnLoginSuccessState ||
                        current is OnLoginErrorState ||
                        current is OnLoginCatchErrorState;
                  },
                  listener: (context, state) {
                    if (state is OnLoginSuccessState) {
                      AppConstant.toast(
                        "Login successfully.",
                        AppColors.greenColor,
                      );
                      context.pushNamedAndRemoveUntil(
                        Routes.buttonNavigationBarScreen,
                        predicate: (predicate) => false,
                      );
                    } else if (state is OnLoginErrorState) {
                      AppConstant.toast(
                        "The email or password has an error",
                        AppColors.redColor,
                      );
                    } else if (state is OnLoginCatchErrorState) {
                      AppConstant.toast(
                        "An error occurred, try again",
                        AppColors.redColor,
                      );
                    }
                  },
                  builder: (context, state) {
                    return ButtonWidget(
                      isLoading: state is OnLoginLoadingState,
                      buttonWidth: double.infinity,
                      buttonHeight: 52.h,
                      borderRadius: 12.r,
                      buttonText: "Sign In",
                      backGroundColor: const Color(0xff069C54),
                      borderColor: Colors.transparent,
                      textStyle: TextStyles.font16WhiteColorWeight600.copyWith(
                        fontSize: 16.sp,
                      ),
                      onPressed: () {
                        validateRegister(context);
                      },
                    );
                  },
                ),

                verticalSpace(32),

                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.greyColorDA,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "Or continue with",
                        style: TextStyles.font14GreyColor87Weight400.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.greyColorDA,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                verticalSpace(24),

                // Social buttons
                _buildSocialButton(
                  icon:
                      "G", // Replaced with a simple formatted text to imitate google icon since standard material doesn't have it colorful
                  isGoogle: true,
                  text: "Sign in with Google",
                  onTap: () {},
                ),
                verticalSpace(16),
                _buildSocialButton(
                  icon: Icons.apple,
                  isGoogle: false,
                  text: "Sign in with Apple",
                  onTap: () {},
                ),

                verticalSpace(40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account? ",
                      style: TextStyles.font14GreyColor87Weight400.copyWith(
                        color: AppColors.greyColor87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // context.pushNamed(Routes.registerScreen);
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyles.font14greenColor3EWeight600.copyWith(
                          color: const Color(0xff069C54),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpace(24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    dynamic icon,
    required bool isGoogle,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.greyColorDA, width: 1),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isGoogle
                ? Text(
                    "G",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  )
                : Icon(icon as IconData, color: Colors.black, size: 28.r),
            horizontalSpace(12),
            Text(
              text,
              style: TextStyles.font16BlackColorWeight600.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validateRegister(BuildContext context) {
    if (LoginCubit.get(context).loginKey.currentState!.validate()) {
      LoginCubit.get(context).login();
    }
  }
}
