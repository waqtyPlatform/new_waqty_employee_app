import 'package:new_waqty_employee_app/features/auth/reset_password/data/models/reset_password_response_model.dart';

abstract class ResetPasswordState {}

class ResetPasswordInitialState extends ResetPasswordState {}

class ResetPasswordLoadingState extends ResetPasswordState {}

class ResetPasswordSuccessState extends ResetPasswordState {
  final ResetPasswordResponseModel response;
  ResetPasswordSuccessState({required this.response});
}

class ResetPasswordErrorState extends ResetPasswordState {
  final String message;
  ResetPasswordErrorState({required this.message});
}

class ResetPasswordCatchErrorState extends ResetPasswordState {}

class IsPasswordVisibleState extends ResetPasswordState {}

class IsConfirmPasswordVisibleState extends ResetPasswordState {}

class OnChangeSelectedFieldState extends ResetPasswordState {}
