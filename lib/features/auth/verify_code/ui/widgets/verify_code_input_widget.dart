import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/app_text_field.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/logic/verify_code_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/logic/verify_code_state.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/services.dart';

class VerifyCodeInputWidget extends StatelessWidget {
  final String email;
  const VerifyCodeInputWidget({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Pinput(
      length: 4,
      enableSuggestions: true,
      showCursor: true,
      keyboardType: TextInputType.number,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      controller: VerifyCodeCubit.get(context).codeController,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      pinputAutovalidateMode: PinputAutovalidateMode.disabled,
      defaultPinTheme: PinTheme(
        width: 70.w,
        height: 50.h,
        textStyle: TextStyles.font16greyColor900Weight400,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.greyColor1001, width: 1.3),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      focusedPinTheme: PinTheme(
        width: 70.w,
        height: 50.h,
        textStyle: TextStyles.font16greyColor900Weight400,
        decoration: BoxDecoration(
          color: AppColors.greenColor505,
          border: Border.all(color: AppColors.greenColor500, width: 1.3),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      submittedPinTheme: PinTheme(
        width: 70.w,
        height: 50.h,
        textStyle: TextStyles.font16greyColor900Weight400,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.greyColor1001, width: 1.3),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      onCompleted: (String? value) {
        VerifyCodeCubit.get(context).verifyCode(email);
        // if (MyConnectivity.isOnline()) {
        // SendCodeCubit.get(context).verifyCode();
        // } else {
        //   AppConstant.toast("Check Internet Connection", AppColors.redColor);
        // }
      },
    );
  }
}
