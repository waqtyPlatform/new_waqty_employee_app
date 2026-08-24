import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/home/data/models/home_summary_model.dart';
import 'package:new_waqty_employee_app/features/home/data/services/home_api_end_points.dart';

class HomeService {
  ApiConsumer apiConsumer;

  HomeService({required this.apiConsumer});

  Future<HomeSummaryModel> getHomeSummary({
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      HomeApiEndPoints.home,
      await _headers(languageCode),
    );

    return HomeSummaryModel.fromJson(_okOrThrow(response));
  }

  Map<String, dynamic> _okOrThrow(dynamic response) {
    final body = _decodeMap(response.body);
    if (response.statusCode == StatusCode.ok) return body;
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
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
    final decodedBody = jsonDecode(body);
    if (decodedBody is Map<String, dynamic>) return decodedBody;
    if (decodedBody is Map) return Map<String, dynamic>.from(decodedBody);
    return <String, dynamic>{};
  }
}
