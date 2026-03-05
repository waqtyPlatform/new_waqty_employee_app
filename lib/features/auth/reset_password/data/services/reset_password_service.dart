import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/data/models/reset_password_request_model.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/data/services/reset_password_api_end_points.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/data/models/reset_password_response_model.dart';

class ResetPasswordService {
  ApiConsumer apiConsumer;

  ResetPasswordService({required this.apiConsumer});

  Future<ResetPasswordResponseModel> resetPassword(
    ResetPasswordRequestModel parameter,
  ) async {
    final response = await apiConsumer.post(
      ResetPasswordApiEndPoints.resetPassword,
      ResetPasswordRequestModel(
        email: parameter.email,
        password: parameter.password,
        passwordConfirmation: parameter.passwordConfirmation,
      ).toJson(),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok) {
      return ResetPasswordResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
