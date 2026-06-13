import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class AppPinTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const AppPinTextFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      style: TextStyles.font16greyColor900Weight600,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyles.font14greyColorA3W400,
        filled: true,
        fillColor: AppColors.whiteColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: _border(AppColors.greyColorE5),
        enabledBorder: _border(AppColors.greyColorE5),
        focusedBorder: _border(AppColors.greenColor500),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.r),
      borderSide: BorderSide(color: color, width: .8.w),
    );
  }
}
