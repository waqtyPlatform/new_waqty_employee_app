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

  static ResetPasswordCubit get(context) => BlocProvider.of(context);
}
