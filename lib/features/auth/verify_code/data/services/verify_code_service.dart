import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/data/models/verify_code_request_model.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/data/services/verify_code_api_end_points.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/data/models/verify_code_response_model.dart';

class VerifyCodeService {
  ApiConsumer apiConsumer;

  VerifyCodeService({required this.apiConsumer});

  Future<VerifyCodeResponseModel> verifyCode(
    VerifyCodeRequestModel parameter,
  ) async {
    final response = await apiConsumer.post(
      VerifyCodeApiEndPoints.verifyCode,
      VerifyCodeRequestModel(
        email: parameter.email,
        otp: parameter.otp,
      ).toJson(),
      {
        ConstantKeys.appAuthorization:
            "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
      },
    );

    if (response.statusCode == StatusCode.ok) {
      return VerifyCodeResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
