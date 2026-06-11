import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/data/models/branch_contact_response_model.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/data/services/branch_contact_api_end_points.dart';

class BranchContactService {
  final ApiConsumer apiConsumer;

  BranchContactService({required this.apiConsumer});

  Future<BranchContactResponseModel> getBranchContact(
    String languageCode,
  ) async {
    final response = await apiConsumer.get(
      BranchContactApiEndPoints.getBranchContact,
      {
        ConstantKeys.appAuthorization:
            '${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}',
        ConstantKeys.acceptLanguage: languageCode,
        ConstantKeys.contentType: ConstantKeys.applicationJson,
        ConstantKeys.acceptText: ConstantKeys.applicationJson,
      },
    );

    if (response.statusCode == StatusCode.ok) {
      return BranchContactResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
