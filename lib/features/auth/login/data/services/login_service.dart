import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/auth/login/data/models/login_request_model.dart';
import 'package:new_waqty_employee_app/features/auth/login/data/services/login_api_end_points.dart';
import 'package:new_waqty_employee_app/features/auth/login/data/models/login_response_model.dart';

class LoginService {
  ApiConsumer apiConsumer;

  LoginService({required this.apiConsumer});

  Future<LoginResponseModel> login(LoginRequestModel parameter) async {
    final response = await apiConsumer.post(
      LoginApiEndPoints.login,
      LoginRequestModel(
        email: parameter.email,
        password: parameter.password,
      ).toJson(),
   null
    );
    if (response.statusCode == StatusCode.ok) {
      return LoginResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
