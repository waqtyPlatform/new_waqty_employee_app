abstract class VerifyCodeState {}

class VerifyCodeInitialState extends VerifyCodeState {}

class VerifyCodeLoadingState extends VerifyCodeState {}

class VerifyCodeSuccessState extends VerifyCodeState {}

class VerifyCodeErrorState extends VerifyCodeState {
  final String message;
  VerifyCodeErrorState({required this.message});
}

class OnChangeSelectedFieldState extends VerifyCodeState {}

class ResendTimerTickState extends VerifyCodeState {
  final int remainingSeconds;
  ResendTimerTickState({required this.remainingSeconds});
}

class ResendTimerFinishedState extends VerifyCodeState {}
