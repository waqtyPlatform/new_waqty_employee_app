import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/end_points.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/models/my_reviews_response_model.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/models/my_stats_response_model.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/services/my_stats_api_end_points.dart';

class MyStatsService {
  final ApiConsumer apiConsumer;

  MyStatsService({required this.apiConsumer});

  Future<MyStatsResponseModel> getPerformance({
    required String period,
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      '${EndPoints.baseUrl}${MyStatsApiEndPoints.performance(period: period)}',
      await _headers(languageCode),
    );
    return MyStatsResponseModel.fromJson(_okOrThrow(response));
  }

  Future<MyReviewsResponseModel> getReviews({
    required String languageCode,
    int? rating,
    String? bookingUuid,
    String? fromDate,
    String? toDate,
    bool? active,
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await apiConsumer.get(
      '${EndPoints.baseUrl}${MyStatsApiEndPoints.ratings(rating: rating, bookingUuid: bookingUuid, fromDate: fromDate, toDate: toDate, active: active, page: page, perPage: perPage)}',
      await _headers(languageCode),
    );
    return MyReviewsResponseModel.fromJson(_okOrThrow(response));
  }

  Map<String, dynamic> _okOrThrow(dynamic response) {
    final body = _decodeMap(response.body);
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      return body;
    }
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<Map<String, String>> _headers(String languageCode) async {
    return {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
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
