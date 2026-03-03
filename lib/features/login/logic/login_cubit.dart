import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/login/data/models/login_request_model.dart';
import 'package:new_waqty_employee_app/features/login/data/repo/login_repo.dart';
import 'package:new_waqty_employee_app/features/login/logic/login_state.dart';
import 'package:new_waqty_employee_app/features/login/data/models/login_response_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo _loginRepo;

  LoginCubit(this._loginRepo) : super(InitialState());

  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login() {
    emit(OnLoginLoadingState());
    _loginRepo
        .login(
          LoginRequestModel(
            email: emailController.text,
            password: passwordController.text,
          ),
        )
        .then((value) {
          value.fold(
            (l) {
              emit(OnLoginErrorState());
            },
            (r) async {
              await cashUserData(r);
              emit(OnLoginSuccessState());
            },
          );
        })
        .catchError((error) {
          emit(OnLoginCatchErrorState());
        });
  }

  Future<void> cashUserData(LoginResponseModel response) async {
    await CacheHelper.setSecuredString(
      ConstantKeys.saveNameToShared,
      response.customer.name,
    );
    await CacheHelper.setSecuredString(
      ConstantKeys.savePhoneToShared,
      response.customer.phone,
    );
    await CacheHelper.setSecuredString(
      ConstantKeys.saveEmailToShared,
      response.customer.email,
    );
    await CacheHelper.setSecuredString(
      ConstantKeys.saveTokenToShared,
      response.token,
    );
  }

  static LoginCubit get(context) => BlocProvider.of(context);
}
