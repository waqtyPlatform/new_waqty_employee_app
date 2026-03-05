import 'package:new_waqty_employee_app/features/auth/reset_password/data/models/reset_password_request_model.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/data/repo/reset_password_repo.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/logic/reset_password_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordRepo _resetPasswordRepo;

  ResetPasswordCubit(this._resetPasswordRepo)
    : super(ResetPasswordInitialState());

  GlobalKey<FormState> resetPasswordKey = GlobalKey();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  int selectedFieldNumber = 0;
  changeSelectedField(int value) {
    selectedFieldNumber = value;
    emit(OnChangeSelectedFieldState());
  }

  bool isPasswordVisible = true;
  changePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(IsPasswordVisibleState());
  }

  bool isConfirmPasswordVisible = true;
  changeConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    emit(IsConfirmPasswordVisibleState());
  }

  Future<void> resetPassword(String email, String otp) async {
    emit(ResetPasswordLoadingState());

    final result = await _resetPasswordRepo
        .resetPassword(
          ResetPasswordRequestModel(
            email: email,
            otp: otp,
            newPassword: passwordController.text,
            newPasswordConfirmation: confirmPasswordController.text,
          ),
        )
        .catchError((error) {
          emit(ResetPasswordCatchErrorState());
        });

    result.fold((failure) {
      if (failure.message.isNotEmpty) {
        emit(ResetPasswordErrorState(message: failure.message));
      } else {
        emit(ResetPasswordCatchErrorState());
      }
    }, (response) => emit(ResetPasswordSuccessState(response: response)));
  }

  static ResetPasswordCubit get(context) => BlocProvider.of(context);
}
