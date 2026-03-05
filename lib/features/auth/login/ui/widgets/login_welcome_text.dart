import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class LoginWelcomeText extends StatelessWidget {
  const LoginWelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpace(20),
        Text('Welcome Back! 👋', style: TextStyles.font24greyColor900Weight600),
        verticalSpace(12),
        Text(
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
          style: TextStyles.font14greyColor4002Weight400,
        ),
      ],
    );
  }
}
