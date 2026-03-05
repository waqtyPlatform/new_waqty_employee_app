import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/data/models/forget_password_request_model.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/data/services/forget_password_api_end_points.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/data/models/forget_password_response_model.dart';

class ForgetPasswordService {
  ApiConsumer apiConsumer;

  ForgetPasswordService({required this.apiConsumer});

  Future<ForgetPasswordResponseModel> forgetPassword(
    ForgetPasswordRequestModel parameter,
  ) async {
    final response = await apiConsumer.post(
      ForgetPasswordApiEndPoints.forgetPassword,
      ForgetPasswordRequestModel(email: parameter.email).toJson(),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok) {
      return ForgetPasswordResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
