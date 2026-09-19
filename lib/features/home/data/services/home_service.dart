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

  Future<HomeSnapshotModel> getTodaySnapshot({
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      HomeApiEndPoints.todaySnapshot,
      await _headers(languageCode),
    );
    final data = _okOrThrow(response)['data'];
    final snapshot = data is Map ? data['snapshot'] : null;
    return HomeSnapshotModel.fromJson(_asMap(snapshot));
  }

  Future<HomeEarningsModel> getTodayEarnings({
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      HomeApiEndPoints.todayEarnings,
      await _headers(languageCode),
    );
    final data = _okOrThrow(response)['data'];
    final earnings = data is Map ? data['earnings'] : null;
    return HomeEarningsModel.fromJson(_asMap(earnings));
  }

  Future<List<HomeAppointmentModel>> getUpcomingAppointments({
    required String languageCode,
    int limit = 5,
  }) async {
    final response = await apiConsumer.get(
      HomeApiEndPoints.upcomingAppointments(limit: limit),
      await _headers(languageCode),
    );
    final data = _okOrThrow(response)['data'];
    final appointments = data is Map ? data['upcoming_appointments'] : null;
    return _asList(appointments).map(HomeAppointmentModel.fromJson).toList();
  }

  Future<HomeReviewModel?> getLatestReview({
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      HomeApiEndPoints.latestReview,
      await _headers(languageCode),
    );
    final data = _okOrThrow(response)['data'];
    final review = data is Map ? data['latest_review'] : null;
    final reviewMap = _asMap(review);
    return reviewMap.isEmpty ? null : HomeReviewModel.fromJson(reviewMap);
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

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _asList(dynamic value) {
    return (value is List ? value : const [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }
}
