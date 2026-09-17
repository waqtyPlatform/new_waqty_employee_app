import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/account/my_requests/data/services/my_requests_api_end_points.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/attendance_session_model.dart';

class MyRequestsService {
  final ApiConsumer apiConsumer;

  MyRequestsService({required this.apiConsumer});

  Future<AttendanceCurrentModel> getCurrentSession({
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      MyRequestsApiEndPoints.currentAttendance,
      await _headers(languageCode),
    );

    final body = _decodeMap(response.body);
    if (response.statusCode == StatusCode.ok) {
      return AttendanceCurrentModel.fromJson(body);
    }
    throw ServerException(serverFailure: ServerFailure.fromJson(body));
  }

  Future<EarlyDepartureModel?> requestEarlyDeparture({
    required String languageCode,
    required String attendanceSessionUuid,
    required String reason,
  }) async {
    final response = await apiConsumer.post(
      MyRequestsApiEndPoints.earlyDepartureRequest,
      {'attendance_session_uuid': attendanceSessionUuid, 'reason': reason},
      await _headers(languageCode),
    );

    final body = _decodeMap(response.body);
    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final data = _asMap(body['data']);
      final earlyDeparture = _asMap(data['early_departure']);
      if (earlyDeparture.isEmpty) return null;
      return EarlyDepartureModel.fromJson(earlyDeparture);
    }
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
}
