import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/app_text_field.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/logic/reset_password_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/logic/reset_password_state.dart';

class ResetPasswordConfirmPasswordWidget extends StatelessWidget {
  const ResetPasswordConfirmPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      buildWhen: (previous, current) {
        return current is IsConfirmPasswordVisibleState ||
            current is OnChangeSelectedFieldState;
      },
      builder: (context, state) {
        return AppTextFormField(
          hintText: '************',
          hintStyle: TextStyles.font16greyColor4002Weight400,
          contentPadding: EdgeInsets.symmetric(
            vertical: 11.h,
            horizontal: 12.w,
          ),
          textStyle: TextStyles.font16greyColor900Weight400,
          controller: ResetPasswordCubit.get(context).confirmPasswordController,
          isObscureText: ResetPasswordCubit.get(
            context,
          ).isConfirmPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              ResetPasswordCubit.get(context).isConfirmPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: AppColors.greyColor3003,
            ),
            onPressed: () {
              ResetPasswordCubit.get(context).changeConfirmPasswordVisibility();
            },
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.greyColor1001, width: 1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.greenColor500, width: 1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.errorColor100, width: 1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.errorColor100, width: 1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value !=
                ResetPasswordCubit.get(context).passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
          backgroundColor:
              ResetPasswordCubit.get(context).selectedFieldNumber == 2
              ? AppColors.greenColor505
              : AppColors.whiteColor,
          onTap: () {
            ResetPasswordCubit.get(context).changeSelectedField(2);
          },
          onTapOutside: () {
            ResetPasswordCubit.get(context).changeSelectedField(0);
          },
          keyboardType: TextInputType.visiblePassword,
        );
      },
    );
  }
}
