abstract class LoginState {}

class InitialState extends LoginState {}

class OnLoginLoadingState extends LoginState {}

class OnLoginSuccessState extends LoginState {}

class OnLoginErrorState extends LoginState {}

class OnLoginCatchErrorState extends LoginState {}
