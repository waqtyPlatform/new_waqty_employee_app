import 'package:new_waqty_employee_app/features/auth/forget_password/data/models/forget_password_response_model.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/data/models/verify_code_response_model.dart';

abstract class VerifyCodeState {}

class VerifyCodeInitialState extends VerifyCodeState {}

class VerifyCodeLoadingState extends VerifyCodeState {}

class VerifyCodeSuccessState extends VerifyCodeState {
  final VerifyCodeResponseModel response;
  VerifyCodeSuccessState({required this.response});
}

class VerifyCodeErrorState extends VerifyCodeState {
  final String message;
  VerifyCodeErrorState({required this.message});
}

class VerifyCodeCatchErrorState extends VerifyCodeState {}

class OnChangeSelectedFieldState extends VerifyCodeState {}

class ResendTimerTickState extends VerifyCodeState {
  final int remainingSeconds;
  ResendTimerTickState({required this.remainingSeconds});
}

class ResendTimerFinishedState extends VerifyCodeState {}

class ResendCodeLoadingState extends VerifyCodeState {}

class ResendCodeSuccessState extends VerifyCodeState {
  final ForgetPasswordResponseModel response;
  ResendCodeSuccessState({required this.response});
}

class ResendCodeErrorState extends VerifyCodeState {
  final String message;
  ResendCodeErrorState({required this.message});
}

class ResendCodeCatchErrorState extends VerifyCodeState {}
