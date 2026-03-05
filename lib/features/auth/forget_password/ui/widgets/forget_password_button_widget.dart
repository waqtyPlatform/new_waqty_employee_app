import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
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
      listener: (context, state) {
        // Handle success/error states
      },
      builder: (context, state) {
        return ButtonWidget(
          isLoading: false,
          borderRadius: 12,
          buttonHeight: 50.h,
          buttonText: 'Send OTP',
          backGroundColor: AppColors.greenColor500,
          borderColor: AppColors.greenColor500,
          textStyle: TextStyles.font16whiteColorWeight600,
          onPressed: () {
            context.pushNamed(Routes.verifyCodeScreen);
          },
        );
      },
    );
  }
}
