abstract class LoginState {}

class InitialState extends LoginState {}

class IsPasswordVisibleState extends LoginState {}

class OnChangeSelectedFieldState extends LoginState {}

class OnLoginLoadingState extends LoginState {}

class OnLoginSuccessState extends LoginState {}

class OnLoginErrorState extends LoginState {
  final String message;
  OnLoginErrorState({required this.message});
}

class OnLoginCatchErrorState extends LoginState {}
