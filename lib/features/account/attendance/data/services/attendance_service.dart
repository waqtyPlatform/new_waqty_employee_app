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
      return AttendanceResponseModel.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException(
        serverFailure: ServerFailure.fromJson(jsonDecode(response.body)),
      );
    }
  }
}
