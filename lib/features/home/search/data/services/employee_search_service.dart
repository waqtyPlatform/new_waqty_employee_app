import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/home/search/data/models/employee_search_models.dart';
import 'package:new_waqty_employee_app/features/home/search/data/services/employee_search_api_end_points.dart';

class EmployeeSearchService {
  final ApiConsumer apiConsumer;

  EmployeeSearchService({required this.apiConsumer});

  Future<EmployeeSearchResponseModel> search({
    required String query,
    required String type,
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      EmployeeSearchApiEndPoints.search(query: query, type: type),
      await _headers(languageCode),
    );

    if (response.statusCode == StatusCode.ok) {
      return EmployeeSearchResponseModel.fromJson(_decode(response.body));
    }
    throw ServerException(
      serverFailure: ServerFailure.fromJson(_decode(response.body)),
    );
  }

  Future<EmployeeCustomerAppointmentsResponseModel> customerAppointments({
    required String customerUuid,
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      EmployeeSearchApiEndPoints.customerAppointments(customerUuid),
      await _headers(languageCode),
    );

    if (response.statusCode == StatusCode.ok) {
      return EmployeeCustomerAppointmentsResponseModel.fromJson(
        _decode(response.body),
      );
    }
    throw ServerException(
      serverFailure: ServerFailure.fromJson(_decode(response.body)),
    );
  }

  Future<Map<String, String>> _headers(String languageCode) async {
    return {
      ConstantKeys.appAuthorization:
          '${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}',
      ConstantKeys.acceptLanguage: languageCode,
      ConstantKeys.contentType: ConstantKeys.applicationJson,
      ConstantKeys.acceptText: ConstantKeys.applicationJson,
    };
  }

  Map<String, dynamic> _decode(String body) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    return <String, dynamic>{};
  }
}
