import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/auth/login/data/models/login_request_model.dart';
import 'package:new_waqty_employee_app/features/auth/login/data/repo/login_repo.dart';
import 'package:new_waqty_employee_app/features/auth/login/logic/login_state.dart';
import 'package:new_waqty_employee_app/features/auth/login/data/models/login_response_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;

  LoginCubit(this._loginRepo) : super(InitialState());

  GlobalKey<FormState> loginKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();

  int selectedFieldNumber = 0;
  changeSelectedField(int value) {
    selectedFieldNumber = value;
    emit(OnChangeSelectedFieldState());
  }

  bool isPasswordVisibleLogin = true;

  changePasswordLoginState() {
    isPasswordVisibleLogin = !isPasswordVisibleLogin;
    emit(IsPasswordVisibleState());
  }

  Future<void> login() async {
    emit(OnLoginLoadingState());
    final response = await _loginRepo
        .login(
          LoginRequestModel(
            email: emailController.text,
            password: passwordController.text,
          ),
        )
        .catchError((error) {
          emit(OnLoginCatchErrorState());
        });
    response.fold(
      (failure) {
        if (failure.message.isNotEmpty) {
          emit(OnLoginErrorState(message: failure.message));
        } else {
          emit(OnLoginCatchErrorState());
        }
      },
      (result) async {
        await cashUserData(result);
        emit(OnLoginSuccessState());
      },
    );
  }

  Future<void> cashUserData(LoginResponseModel response) async {
    await CacheHelper.setSecuredString(
      ConstantKeys.saveTokenToShared,
      response.token,
    );
  }

  static LoginCubit get(context) => BlocProvider.of(context);
}
