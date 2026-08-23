import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/data/models/customer_context_model.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/data/services/customer_context_api_end_points.dart';

class CustomerContextService {
  final ApiConsumer apiConsumer;

  CustomerContextService({required this.apiConsumer});

  Future<CustomerContextResponseModel> getCustomerContext({
    required String customerUuid,
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      CustomerContextApiEndPoints.context(customerUuid),
      await _headers(languageCode),
    );

    if (response.statusCode == StatusCode.ok) {
      return CustomerContextResponseModel.fromJson(_decodeMap(response.body));
    }
    _throwServerFailure(response);
  }

  Future<CustomerPackagesResponseModel> getCustomerPackages({
    required String customerUuid,
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      CustomerContextApiEndPoints.packages(customerUuid),
      await _headers(languageCode),
    );

    if (response.statusCode == StatusCode.ok) {
      return CustomerPackagesResponseModel.fromJson(_decodeMap(response.body));
    }
    _throwServerFailure(response);
  }

  Future<CustomerFollowUpsResponseModel> getCustomerFollowUps({
    required String customerUuid,
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      CustomerContextApiEndPoints.followUps(customerUuid),
      await _headers(languageCode),
    );

    if (response.statusCode == StatusCode.ok) {
      return CustomerFollowUpsResponseModel.fromJson(_decodeMap(response.body));
    }
    _throwServerFailure(response);
  }

  Future<CustomerContextResponseModel> assignPackage({
    required String customerUuid,
    required String packageUuid,
    required String languageCode,
  }) async {
    final response = await apiConsumer.post(
      CustomerContextApiEndPoints.packages(customerUuid),
      {'package_uuid': packageUuid, 'mode': 'purchase_only'},
      await _headers(languageCode),
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return CustomerContextResponseModel.fromJson(_decodeMap(response.body));
    }
    _throwServerFailure(response);
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

  Map<String, dynamic> _decodeMap(String body) {
    try {
      final decodedBody = jsonDecode(body);
      if (decodedBody is Map<String, dynamic>) return decodedBody;
      if (decodedBody is Map) return Map<String, dynamic>.from(decodedBody);
    } catch (_) {}
    throw const ServerException(
      serverFailure: ServerFailure(message: 'Invalid server response'),
    );
  }

  Never _throwServerFailure(dynamic response) {
    String message = '';
    try {
      final decodedBody = jsonDecode(response.body);
      if (decodedBody is Map) {
        message =
            decodedBody['message']?.toString() ??
            decodedBody['code']?.toString() ??
            '';
      }
    } catch (_) {}

    throw ServerException(
      serverFailure: ServerFailure(
        message: message.isEmpty ? 'Server error' : message,
      ),
    );
  }
}
