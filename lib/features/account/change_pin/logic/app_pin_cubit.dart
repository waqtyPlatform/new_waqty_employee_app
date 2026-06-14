import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/biometric/data/services/biometric_auth_service.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/data/services/app_pin_service.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/logic/app_pin_state.dart';

class AppPinCubit extends Cubit<AppPinState> {
  final AppPinService _appPinService;
  final BiometricAuthService? _biometricAuthService;

  bool isPinEnabled = false;
  bool isBiometricEnabled = false;
  bool isBiometricSupported = false;
  bool hasEnrolledBiometrics = false;
  String biometricStatusKey = 'biometricLogin.statusUnknown';
  String biometricDeviceName = '';
  String biometricMethod = '';
  String biometricEnabledAtText = '';
  String biometricLastUsedText = '';
  int remainingLockSeconds = 0;

  AppPinCubit(this._appPinService, [this._biometricAuthService])
    : super(AppPinInitialState());

  static AppPinCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> loadPinStatus() async {
    emit(AppPinLoadingState());
    isPinEnabled = await _appPinService.isPinEnabled();
    isBiometricEnabled = await _appPinService.isBiometricEnabled();
    await _loadBiometricAvailability();
    await _loadBiometricDetails();
    emit(AppPinStatusChangedState());
  }

  Future<void> loadSecuritySettings() => loadPinStatus();

  Future<void> enablePin({
    required String pin,
    required String confirmPin,
  }) async {
    final validationKey = _validateNewPin(pin: pin, confirmPin: confirmPin);
    if (validationKey != null) {
      emit(AppPinErrorState(validationKey));
      return;
    }

    emit(AppPinLoadingState());
    await _appPinService.setPin(pin);
    isPinEnabled = true;
    emit(AppPinSuccessState('appPin.pinEnabledSuccess'));
  }

  Future<void> verifyPin(String pin) async {
    if (await _emitLockStateIfNeeded()) return;

    if (pin.isEmpty) {
      emit(AppPinErrorState('appPin.pinRequired'));
      return;
    }
    if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
      emit(AppPinErrorState('appPin.pinLength'));
      return;
    }

    emit(AppPinLoadingState());
    final isValid = await _appPinService.verifyPin(pin);
    if (isValid) {
      await _appPinService.resetFailedAttempts();
      remainingLockSeconds = 0;
      emit(AppPinVerifiedState());
      return;
    }

    final attempts = await _appPinService.increaseFailedAttempts();
    if (attempts >= 5) {
      await _appPinService.logoutAndClearSecurityData();
      emit(AppPinForceLogoutState());
      return;
    }

    if (await _emitLockStateIfNeeded()) return;
    emit(AppPinErrorState('appPin.invalidPin'));
  }

  Future<void> changePin({
    required String currentPin,
    required String newPin,
    required String confirmPin,
  }) async {
    if (currentPin.isEmpty) {
      emit(AppPinErrorState('appPin.currentPinRequired'));
      return;
    }

    final validationKey = _validateNewPin(pin: newPin, confirmPin: confirmPin);
    if (validationKey != null) {
      emit(AppPinErrorState(validationKey));
      return;
    }

    emit(AppPinLoadingState());
    final changed = await _appPinService.changePin(
      currentPin: currentPin,
      newPin: newPin,
    );
    if (!changed) {
      emit(AppPinErrorState('appPin.currentPinWrong'));
      return;
    }

    isPinEnabled = true;
    emit(AppPinSuccessState('appPin.pinChangedSuccess'));
  }

  Future<void> verifyCurrentPinForChange(String currentPin) async {
    if (currentPin.isEmpty) {
      emit(AppPinErrorState('appPin.currentPinRequired'));
      return;
    }
    if (!RegExp(r'^\d{4}$').hasMatch(currentPin)) {
      emit(AppPinErrorState('appPin.pinLength'));
      return;
    }

    emit(AppPinLoadingState());
    final isValid = await _appPinService.verifyPin(currentPin);
    if (!isValid) {
      emit(AppPinErrorState('appPin.currentPinWrong'));
      return;
    }

    emit(AppPinCurrentPinVerifiedState());
  }

  Future<void> disablePin(String currentPin) async {
    if (currentPin.isEmpty) {
      emit(AppPinErrorState('appPin.currentPinRequired'));
      return;
    }

    emit(AppPinLoadingState());
    final disabled = await _appPinService.disablePin(currentPin);
    if (!disabled) {
      emit(AppPinErrorState('appPin.currentPinWrong'));
      return;
    }

    isPinEnabled = false;
    emit(AppPinSuccessState('appPin.pinDisabledSuccess'));
  }

  Future<void> forgotPin() async {
    emit(AppPinLoadingState());
    await _appPinService.forgotPin();
    isPinEnabled = false;
    isBiometricEnabled = false;
    emit(AppPinForceLogoutState());
  }

  Future<void> enableBiometric({String? currentPin}) async {
    final biometricAuthService = _biometricAuthService;
    if (biometricAuthService == null) {
      emit(AppPinErrorState('biometricLogin.unavailable'));
      return;
    }

    emit(BiometricCheckingState());
    await _loadBiometricAvailability();

    if (!isBiometricSupported) {
      emit(BiometricNotSupportedState());
      return;
    }

    if (!hasEnrolledBiometrics) {
      emit(BiometricNotEnrolledState());
      return;
    }

    if (isPinEnabled) {
      final pin = currentPin ?? '';
      if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
        emit(AppPinErrorState('appPin.pinLength'));
        return;
      }

      final isCurrentPinValid = await _appPinService.verifyPin(pin);
      if (!isCurrentPinValid) {
        emit(AppPinErrorState('appPin.currentPinWrong'));
        return;
      }
    }

    final authenticated = await biometricAuthService.authenticate(
      reason: 'Authenticate to enable biometric login.',
    );
    if (!authenticated) {
      emit(BiometricAuthFailureState('biometricLogin.authFailed'));
      return;
    }

    await _appPinService.setBiometricEnabled(true);
    isBiometricEnabled = true;
    biometricStatusKey = 'biometricLogin.statusEnabled';
    await _loadBiometricDetails();
    emit(BiometricEnabledState());
  }

  Future<void> disableBiometric({
    String? currentPin,
    bool confirmed = false,
  }) async {
    if (isPinEnabled) {
      final pin = currentPin ?? '';
      if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
        emit(AppPinErrorState('appPin.pinLength'));
        return;
      }

      final isCurrentPinValid = await _appPinService.verifyPin(pin);
      if (!isCurrentPinValid) {
        emit(AppPinErrorState('appPin.currentPinWrong'));
        return;
      }
    } else if (!confirmed) {
      emit(AppPinErrorState('biometricLogin.confirmDisableRequired'));
      return;
    }

    emit(AppPinLoadingState());
    await _appPinService.setBiometricEnabled(false);
    isBiometricEnabled = false;
    await _loadBiometricAvailability();
    await _loadBiometricDetails();
    emit(BiometricDisabledState());
  }

  Future<void> authenticateWithBiometric() async {
    final biometricAuthService = _biometricAuthService;
    if (biometricAuthService == null) {
      emit(BiometricAuthFailureState('biometricLogin.unavailable'));
      return;
    }

    emit(BiometricCheckingState());
    isPinEnabled = await _appPinService.isPinEnabled();
    await _loadBiometricAvailability();

    if (!isBiometricSupported) {
      emit(BiometricNotSupportedState());
      return;
    }

    if (!hasEnrolledBiometrics) {
      emit(BiometricNotEnrolledState());
      return;
    }

    final authenticated = await biometricAuthService.authenticate(
      reason: 'Authenticate to unlock Waqty.',
    );
    if (authenticated) {
      await _appPinService.saveBiometricLastUsedNow();
      await _loadBiometricDetails();
      emit(BiometricAuthSuccessState());
      return;
    }

    emit(BiometricAuthFailureState('biometricLogin.authFailed'));
  }

  Future<void> openSecuritySettings() async {
    await _biometricAuthService?.openSecuritySettings();
  }

  Future<void> logoutFromLockScreen() async {
    emit(AppPinLoadingState());
    await _appPinService.logoutAndClearSecurityData();
    emit(AppPinForceLogoutState());
  }

  void goToPinFallback() {
    emit(PinRequiredState());
  }

  Future<void> _loadBiometricAvailability() async {
    final biometricAuthService = _biometricAuthService;
    if (biometricAuthService == null) {
      isBiometricSupported = false;
      hasEnrolledBiometrics = false;
      biometricStatusKey = 'biometricLogin.statusNotSupported';
      return;
    }

    isBiometricSupported = await biometricAuthService.isDeviceSupported();
    hasEnrolledBiometrics = await biometricAuthService.hasEnrolledBiometrics();

    if (!isBiometricSupported) {
      biometricStatusKey = 'biometricLogin.statusNotSupported';
    } else if (!hasEnrolledBiometrics) {
      biometricStatusKey = 'biometricLogin.statusNotEnrolled';
    } else if (isBiometricEnabled) {
      biometricStatusKey = 'biometricLogin.statusEnabled';
    } else {
      biometricStatusKey = 'biometricLogin.statusAvailable';
    }
  }

  Future<void> _loadBiometricDetails() async {
    final biometricAuthService = _biometricAuthService;
    biometricDeviceName =
        await biometricAuthService?.getDeviceName() ?? 'This device';
    biometricMethod =
        await biometricAuthService?.getBiometricMethodLabel() ?? 'Biometric';
    final enabledAt = await _appPinService.getBiometricEnabledAt();
    final lastUsedAt = await _appPinService.getBiometricLastUsedAt();
    biometricEnabledAtText = _formatBiometricDate(enabledAt);
    biometricLastUsedText = _formatBiometricDate(lastUsedAt);
  }

  String _formatBiometricDate(DateTime? value) {
    if (value == null) return '';
    final now = DateTime.now();
    final localValue = value.toLocal();
    final hour12 = localValue.hour % 12 == 0 ? 12 : localValue.hour % 12;
    final minute = localValue.minute.toString().padLeft(2, '0');
    final suffix = localValue.hour >= 12 ? 'PM' : 'AM';
    final time = '$hour12:$minute $suffix';

    final isToday =
        localValue.year == now.year &&
        localValue.month == now.month &&
        localValue.day == now.day;
    if (isToday) return 'Today, $time';

    final day = localValue.day.toString().padLeft(2, '0');
    final month = localValue.month.toString().padLeft(2, '0');
    return '$day/$month/${localValue.year}, $time';
  }

  Future<bool> _emitLockStateIfNeeded() async {
    final isLocked = await _appPinService.isLocked();
    if (!isLocked) {
      remainingLockSeconds = 0;
      return false;
    }

    final lockedUntil = await _appPinService.getLockedUntil();
    remainingLockSeconds =
        lockedUntil?.difference(DateTime.now()).inSeconds.clamp(1, 30) ?? 0;
    emit(AppPinLockedState(remainingLockSeconds));
    return true;
  }

  String? _validateNewPin({required String pin, required String confirmPin}) {
    if (pin.isEmpty || confirmPin.isEmpty) return 'appPin.pinRequired';
    if (!RegExp(r'^\d+$').hasMatch(pin)) return 'appPin.pinDigitsOnly';
    if (pin.length != 4) return 'appPin.pinLength';
    if (pin != confirmPin) return 'appPin.pinMismatch';
    if (_isWeakPin(pin)) return 'appPin.weakPin';
    return null;
  }

  bool _isWeakPin(String pin) {
    const weakPins = {'0000', '1111', '1234', '4321'};
    if (weakPins.contains(pin)) return true;
    return RegExp(r'^(\d)\1+$').hasMatch(pin);
  }
}
