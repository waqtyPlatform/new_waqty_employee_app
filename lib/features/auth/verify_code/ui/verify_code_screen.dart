import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/logic/verify_code_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/ui/widgets/verify_code_input_widget.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/ui/widgets/verify_code_button_widget.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/ui/widgets/resend_code_widget.dart';

class VerifyCodeScreen extends StatelessWidget {
  final String email;
  const VerifyCodeScreen({super.key, required this.email});

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
            key: VerifyCodeCubit.get(context).verifyCodeKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpace(16),
                Text(
                  context.tr('verifyCode.title'),
                  style: TextStyles.font24greyColor900Weight600,
                ),
                verticalSpace(6),
                Text(
                  context.tr('verifyCode.subtitle'),
                  style: TextStyles.font14greyColor4002Weight400,
                ),
                verticalSpace(24),

                VerifyCodeInputWidget(email: email),
                verticalSpace(48),
                ResendCodeWidget(email: email),
                verticalSpace(32),
                VerifyCodeButtonWidget(email: email),

                verticalSpace(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
