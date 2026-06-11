import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/data/models/contact_manager_response_model.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/data/services/contact_manager_api_end_points.dart';

class ContactManagerService {
  final ApiConsumer apiConsumer;

  ContactManagerService({required this.apiConsumer});

  Future<ContactManagerResponseModel> sendMessage({
    required String subject,
    required String message,
    required String priority,
    required String languageCode,
  }) async {
    final response = await apiConsumer.post(
      ContactManagerApiEndPoints.sendMessage,
      {'subject': subject, 'message': message, 'priority': priority},
      {
        ConstantKeys.appAuthorization:
            '${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}',
        ConstantKeys.acceptLanguage: languageCode,
        ConstantKeys.contentType: ConstantKeys.applicationJson,
        ConstantKeys.acceptText: ConstantKeys.applicationJson,
      },
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return ContactManagerResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
