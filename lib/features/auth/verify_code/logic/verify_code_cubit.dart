import 'dart:async';
import 'package:new_waqty_employee_app/features/auth/verify_code/data/repo/verify_code_repo.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/logic/verify_code_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyCodeCubit extends Cubit<VerifyCodeState> {
  final VerifyCodeRepo _verifyCodeRepo;

  VerifyCodeCubit(this._verifyCodeRepo) : super(VerifyCodeInitialState()) {
    startResendTimer();
  }

  GlobalKey<FormState> verifyCodeKey = GlobalKey();
  TextEditingController codeController = TextEditingController();

  int selectedFieldNumber = 0;
  changeSelectedField(int value) {
    selectedFieldNumber = value;
    emit(OnChangeSelectedFieldState());
  }

  /// Resend timer
  Timer? _resendTimer;
  int resendTimerSeconds = 60;
  bool get canResend => resendTimerSeconds == 0;

  String get timerText {
    final minutes = (resendTimerSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (resendTimerSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void startResendTimer() {
    resendTimerSeconds = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimerSeconds > 0) {
        resendTimerSeconds--;
        emit(ResendTimerTickState(remainingSeconds: resendTimerSeconds));
      } else {
        timer.cancel();
        emit(ResendTimerFinishedState());
      }
    });
  }

  void resendCode() {
    if (canResend) {
      startResendTimer();
      // TODO: Call resend API
    }
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    codeController.dispose();
    return super.close();
  }

  static VerifyCodeCubit get(context) => BlocProvider.of(context);
}
