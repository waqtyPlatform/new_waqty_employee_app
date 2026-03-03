import 'package:flutter/material.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';

class AppInterceptor extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    request.headers[ConstantKeys.contentType] = ConstantKeys.applicationJson;
    request.headers[ConstantKeys.acceptText] = ConstantKeys.applicationJson;
    // request.headers[ConstantKeys.acceptLanguage] =
    //     getIt<AppConstant>().getLanguage();
    debugPrint(request.toString());
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    debugPrint(response.toString());
    return response;
  }
}
