import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/logic/verify_code_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/logic/verify_code_state.dart';

class ResendCodeWidget extends StatelessWidget {
  const ResendCodeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerifyCodeCubit, VerifyCodeState>(
      buildWhen: (previous, current) {
        return current is ResendTimerTickState ||
            current is ResendTimerFinishedState;
      },
      builder: (context, state) {
        final cubit = VerifyCodeCubit.get(context);
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!cubit.canResend)
              Text(
                "You can resend the code in ",
                style: TextStyles.font14greyColor500W400,
              ),
            if (cubit.canResend)
              GestureDetector(
                onTap: () => cubit.resendCode(),
                child: Text(
                  'Resend Code',
                  style: TextStyles.font14greenColor500Weight600,
                ),
              )
            else
              Text(
                cubit.timerText,
                style: TextStyles.font14greenColor500Weight400,
              ),
            if (!cubit.canResend)
              Text(" seconds", style: TextStyles.font14greyColor500W400),
          ],
        );
      },
    );
  }
}
