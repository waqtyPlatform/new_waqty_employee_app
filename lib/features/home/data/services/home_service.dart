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

  /// Page size that bounds the rating average — the ratings endpoint has no
  /// aggregate, so anything past this is not counted. 100 is the server max.
  static const int ratingsPageSize = 100;

  /// The four calls run concurrently; the screen is only as slow as the
  /// slowest one.
  Future<HomeSummaryModel> getHomeSummary({required String languageCode}) async {
    final today = _today();
    final headers = await _headers(languageCode);

    final results = await Future.wait([
      _visits(tab: 'upcoming', bookingDate: today, headers: headers),
      _visits(
        tab: 'completed',
        bookingDate: today,
        headers: headers,
        perPage: 1,
      ),
      _revenue(date: today, headers: headers),
      _ratings(headers: headers),
      _profile(headers: headers),
    ]);

    final upcoming = results[0] as HomeVisitsPageModel;
    final completed = results[1] as HomeVisitsPageModel;
    final revenue = results[2] as HomeRevenueModel;
    final ratings = results[3] as HomeRatingsModel;
    final profile = results[4] as HomeProfileModel;

    return HomeSummaryModel(
      employeeName: profile.name,
      branchName: profile.branchName,
      // Cancelled visits are deliberately excluded — "Booked" counts the
      // appointments that still stand today.
      booked: upcoming.total + completed.total,
      done: completed.total,
      left: upcoming.total,
      rating: ratings.average,
      ratingsCount: ratings.count,
      todayEarnings: revenue.totalRevenue,
      currency: 'EGP',
      appointments: upcoming.appointments,
      latestReview: ratings.latest,
    );
  }

  Future<HomeVisitsPageModel> _visits({
    required String tab,
    required String bookingDate,
    required Map<String, String> headers,
    int perPage = 20,
  }) async {
    final response = await apiConsumer.get(
      HomeApiEndPoints.todayVisits(
        tab: tab,
        bookingDate: bookingDate,
        perPage: perPage,
      ),
      headers,
    );

    return HomeVisitsPageModel.fromJson(_okOrThrow(response));
  }

  Future<HomeRevenueModel> _revenue({
    required String date,
    required Map<String, String> headers,
  }) async {
    final response = await apiConsumer.get(
      HomeApiEndPoints.revenue(startDate: date, endDate: date),
      headers,
    );

    return HomeRevenueModel.fromJson(_okOrThrow(response));
  }

  Future<HomeRatingsModel> _ratings({
    required Map<String, String> headers,
  }) async {
    final response = await apiConsumer.get(
      HomeApiEndPoints.ratings(perPage: ratingsPageSize),
      headers,
    );

    return HomeRatingsModel.fromJson(_okOrThrow(response));
  }

  Future<HomeProfileModel> _profile({
    required Map<String, String> headers,
  }) async {
    final response = await apiConsumer.get(HomeApiEndPoints.profile, headers);

    return HomeProfileModel.fromJson(_okOrThrow(response));
  }

  Map<String, dynamic> _okOrThrow(dynamic response) {
    final body = _decodeMap(response.body);
    if (response.statusCode == StatusCode.ok) return body;
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

  static String _today() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
