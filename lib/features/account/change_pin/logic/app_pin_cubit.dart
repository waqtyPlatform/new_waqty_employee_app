import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/data/services/app_pin_service.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/logic/app_pin_state.dart';

class AppPinCubit extends Cubit<AppPinState> {
  final AppPinService _appPinService;

  bool isPinEnabled = false;
  int remainingLockSeconds = 0;

  AppPinCubit(this._appPinService) : super(AppPinInitialState());

  static AppPinCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> loadPinStatus() async {
    emit(AppPinLoadingState());
    isPinEnabled = await _appPinService.isPinEnabled();
    emit(AppPinStatusChangedState());
  }

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
      await _appPinService.clearLoginToken();
      await _appPinService.resetFailedAttempts();
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
    emit(AppPinForceLogoutState());
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
