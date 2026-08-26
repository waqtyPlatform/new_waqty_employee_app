import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_api_end_points.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class PayslipDetailsService {
  final ApiConsumer apiConsumer;

  const PayslipDetailsService({required this.apiConsumer});

  Future<MoneyPayslipDetailModel> getDetails({
    required String uuid,
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      MoneyApiEndPoints.payslipDetails(uuid),
      await _headers(languageCode),
    );
    final body = _decode(response.body);
    if (response.statusCode == StatusCode.ok) {
      return MoneyPayslipDetailModel.fromJson(body);
    }
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<Map<String, String>> _headers(String languageCode) async => {
    ConstantKeys.appAuthorization:
        '${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}',
    ConstantKeys.acceptLanguage: languageCode,
    ConstantKeys.contentType: ConstantKeys.applicationJson,
    ConstantKeys.acceptText: ConstantKeys.applicationJson,
  };

  Map<String, dynamic> _decode(String body) {
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    return <String, dynamic>{};
  }
}
