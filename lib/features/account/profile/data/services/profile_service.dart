import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/attendance_session_model.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/services/profile_api_end_points.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/profile_response_model.dart';

class ProfileService {
  ApiConsumer apiConsumer;

  ProfileService({required this.apiConsumer});

  Future<ProfileResponseModel> getProfile() async {
    final response = await apiConsumer.get(
      ProfileApiEndPoints.getProfile,
      await _headers(),
    );

    if (response.statusCode == StatusCode.ok) {
      return ProfileResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }

  Future<AttendanceCurrentModel> checkCurrentAttendance() async {
    final response = await apiConsumer.get(
      ProfileApiEndPoints.currentAttendance,
      await _headers(),
    );

    if (response.statusCode != StatusCode.ok) {
      return const AttendanceCurrentModel();
    }

    final responseBody = _decodeMap(response.body);
    return AttendanceCurrentModel.fromJson(responseBody);
  }

  Future<AttendanceSessionModel> runAttendanceAction({
    required ProfileAttendanceAction action,
    required double latitude,
    required double longitude,
    required String idempotencyKey,
  }) async {
    final response = await apiConsumer.post(_attendanceActionEndpoint(action), {
      'latitude': latitude,
      'longitude': longitude,
      'idempotency_key': idempotencyKey,
    }, await _headers());

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final data = _decodeMap(response.body)['data'];
      if (data is Map<String, dynamic>) {
        return AttendanceSessionModel.fromJson(data);
      }
      if (data is Map) {
        return AttendanceSessionModel.fromJson(Map<String, dynamic>.from(data));
      }
    }

    throw ServerException(
      serverFailure: ServerFailure.fromJson(_decodeMap(response.body)),
    );
  }

  Future<AttendanceSessionModel> respondPresenceConfirmation({
    required String attendanceSessionUuid,
    required String cycleId,
    required PresenceConfirmationResponse responseValue,
    required double latitude,
    required double longitude,
    required double accuracyMeters,
    required String locationCapturedAt,
    String? expectedEndAt,
  }) async {
    final body = <String, dynamic>{
      'attendance_session_uuid': attendanceSessionUuid,
      'cycle_id': cycleId,
      'response': responseValue.name,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy_meters': accuracyMeters,
      'location_captured_at': locationCapturedAt,
    };

    if (responseValue == PresenceConfirmationResponse.yes &&
        expectedEndAt != null) {
      body['expected_end_at'] = expectedEndAt;
    }

    final response = await apiConsumer.post(
      ProfileApiEndPoints.presenceRespond,
      body,
      await _headers(),
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final data = _decodeMap(response.body)['data'];
      if (data is Map<String, dynamic>) {
        return AttendanceSessionModel.fromJson(data);
      }
      if (data is Map) {
        return AttendanceSessionModel.fromJson(Map<String, dynamic>.from(data));
      }
    }

    throw ServerException(
      serverFailure: ServerFailure.fromJson(_decodeMap(response.body)),
    );
  }

  Future<AttendanceSessionModel> requestEarlyDeparture({
    required String attendanceSessionUuid,
    required String reason,
  }) async {
    final response = await apiConsumer.post(
      ProfileApiEndPoints.earlyDepartureRequest,
      {'attendance_session_uuid': attendanceSessionUuid, 'reason': reason},
      await _headers(),
    );

    if (response.statusCode == StatusCode.ok ||
        response.statusCode == StatusCode.created) {
      final data = _decodeMap(response.body)['data'];
      if (data is Map<String, dynamic>) {
        return AttendanceSessionModel.fromJson(data);
      }
      if (data is Map) {
        return AttendanceSessionModel.fromJson(Map<String, dynamic>.from(data));
      }
    }

    throw ServerException(
      serverFailure: ServerFailure.fromJson(_decodeMap(response.body)),
    );
  }

  Future<Map<String, String>> _headers() async {
    return {
      ConstantKeys.appAuthorization:
          "${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}",
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

  String _attendanceActionEndpoint(ProfileAttendanceAction action) {
    switch (action) {
      case ProfileAttendanceAction.clockIn:
        return ProfileApiEndPoints.clockIn;
      case ProfileAttendanceAction.clockOut:
        return ProfileApiEndPoints.clockOut;
      case ProfileAttendanceAction.startBreak:
        return ProfileApiEndPoints.startBreak;
      case ProfileAttendanceAction.endBreak:
        return ProfileApiEndPoints.endBreak;
    }
  }
}

enum ProfileAttendanceAction { clockIn, clockOut, startBreak, endBreak }

enum PresenceConfirmationResponse { yes, no }
