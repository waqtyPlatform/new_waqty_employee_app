import 'package:new_waqty_employee_app/features/auth/forget_password/data/repo/forget_password_repo.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/logic/forget_password_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ForgetPasswordRepo _forgetPasswordRepo;

  ForgetPasswordCubit(this._forgetPasswordRepo)
    : super(ForgetPasswordInitialState());

  GlobalKey<FormState> forgetPasswordKey = GlobalKey();
  TextEditingController emailController = TextEditingController();

  int selectedFieldNumber = 0;
  changeSelectedField(int value) {
    selectedFieldNumber = value;
    emit(OnChangeSelectedFieldState());
  }

  static ForgetPasswordCubit get(context) => BlocProvider.of(context);
}
