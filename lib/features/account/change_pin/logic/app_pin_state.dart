abstract class AppPinState {}

class AppPinInitialState extends AppPinState {}

class AppPinLoadingState extends AppPinState {}

class AppPinStatusChangedState extends AppPinState {}

class AppPinSuccessState extends AppPinState {
  final String messageKey;

  AppPinSuccessState(this.messageKey);
}

class AppPinErrorState extends AppPinState {
  final String messageKey;

  AppPinErrorState(this.messageKey);
}

class AppPinLockedState extends AppPinState {
  final int remainingSeconds;

  AppPinLockedState(this.remainingSeconds);
}

class AppPinForceLogoutState extends AppPinState {}

class AppPinVerifiedState extends AppPinState {}

class AppPinCurrentPinVerifiedState extends AppPinState {}

class BiometricCheckingState extends AppPinState {}

class BiometricAvailableState extends AppPinState {}

class BiometricNotSupportedState extends AppPinState {}

class BiometricNotEnrolledState extends AppPinState {}

class BiometricAuthSuccessState extends AppPinState {}

class BiometricAuthFailureState extends AppPinState {
  final String messageKey;

  BiometricAuthFailureState(this.messageKey);
}

class BiometricEnabledState extends AppPinState {}

class BiometricDisabledState extends AppPinState {}

class PinRequiredState extends AppPinState {}
