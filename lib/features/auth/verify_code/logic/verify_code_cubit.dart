import 'dart:async';
import 'package:new_waqty_employee_app/features/auth/forget_password/data/models/forget_password_request_model.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/data/repo/forget_password_repo.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/data/models/verify_code_request_model.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/data/repo/verify_code_repo.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/logic/verify_code_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyCodeCubit extends Cubit<VerifyCodeState> {
  final VerifyCodeRepo _verifyCodeRepo;
  final ForgetPasswordRepo _forgetPasswordRepo;

  VerifyCodeCubit(this._verifyCodeRepo, this._forgetPasswordRepo)
    : super(VerifyCodeInitialState()) {
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

  void resendCode(String email) {
    if (canResend) {
      startResendTimer();
      resendCodeFromServer(email);
    }
  }

  Future<void> resendCodeFromServer(String email) async {
    emit(ResendCodeLoadingState());

    final result = await _forgetPasswordRepo
        .forgetPassword(ForgetPasswordRequestModel(email: email))
        .catchError((error) {
          emit(ResendCodeCatchErrorState());
        });

    result.fold(
      (failure) => emit(ResendCodeErrorState(message: failure.message)),
      (response) => emit(ResendCodeSuccessState(response: response)),
    );
  }

  Future<void> verifyCode(String email) async {
    emit(VerifyCodeLoadingState());

    final result = await _verifyCodeRepo
        .verifyCode(
          VerifyCodeRequestModel(email: email, otp: codeController.text),
        )
        .catchError((error) {
          emit(VerifyCodeCatchErrorState());
        });

    result.fold((failure) {
      if (failure.message.isNotEmpty) {
        emit(VerifyCodeErrorState(message: failure.message));
      } else {
        emit(VerifyCodeCatchErrorState());
      }
    }, (response) => emit(VerifyCodeSuccessState(response: response)));
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    codeController.dispose();
    return super.close();
  }

  static VerifyCodeCubit get(context) => BlocProvider.of(context);
}
