import 'dart:convert';

import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/core/api/status_code.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/account/attendance/data/models/attendance_response_model.dart';
import 'package:new_waqty_employee_app/features/account/attendance/data/services/attendance_api_end_points.dart';

class AttendanceService {
  final ApiConsumer apiConsumer;

  AttendanceService({required this.apiConsumer});

  Future<AttendanceResponseModel> getAttendance({
    required String dateFrom,
    required String dateTo,
    required String languageCode,
  }) async {
    final response = await apiConsumer.get(
      AttendanceApiEndPoints.getAttendance(dateFrom: dateFrom, dateTo: dateTo),
      {
        ConstantKeys.appAuthorization:
            '${ConstantKeys.appBearer} ${await CacheHelper.getSecuredString(ConstantKeys.saveTokenToShared)}',
        ConstantKeys.acceptLanguage: languageCode,
        ConstantKeys.contentType: ConstantKeys.applicationJson,
        ConstantKeys.acceptText: ConstantKeys.applicationJson,
      },
    );

    if (response.statusCode == StatusCode.ok) {
      return AttendanceResponseModel.fromJson(_decodeMap(response.body));
    } else {
      _throwServerFailure(response.body);
    }
  }

  Map<String, dynamic> _decodeMap(String body) {
    try {
      final decodedBody = jsonDecode(body);
      return _asMap(decodedBody);
    } on FormatException {
      final fixedBody = _bodyWithMissingClosingBraces(body);
      if (fixedBody != null) {
        final decodedBody = jsonDecode(fixedBody);
        return _asMap(decodedBody);
      }
      throw ServerException(
        serverFailure: const ServerFailure(message: 'Invalid server response'),
      );
    }
  }

  String? _bodyWithMissingClosingBraces(String body) {
    final trimmedBody = body.trimRight();
    if (!trimmedBody.startsWith('{')) return null;

    final missingBraces = _missingClosingBraces(trimmedBody);
    if (missingBraces <= 0 || missingBraces > 2) return null;

    return trimmedBody + ('}' * missingBraces);
  }

  int _missingClosingBraces(String body) {
    var openedBraces = 0;
    var inString = false;
    var isEscaped = false;

    for (final codeUnit in body.codeUnits) {
      final character = String.fromCharCode(codeUnit);
      if (isEscaped) {
        isEscaped = false;
        continue;
      }
      if (character == '\\') {
        isEscaped = true;
        continue;
      }
      if (character == '"') {
        inString = !inString;
        continue;
      }
      if (inString) continue;

      if (character == '{') openedBraces++;
      if (character == '}') openedBraces--;
    }

    return openedBraces;
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  Never _throwServerFailure(String body) {
    final decodedBody = _decodeMap(body);
    throw ServerException(serverFailure: ServerFailure.fromJson(decodedBody));
  }
}
