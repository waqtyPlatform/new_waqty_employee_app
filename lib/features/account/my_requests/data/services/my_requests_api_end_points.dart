import 'package:new_waqty_employee_app/core/api/end_points.dart';

class MyRequestsApiEndPoints {
  static const String currentAttendance =
      '${EndPoints.baseUrl}/employee/attendance/current-session';
  static const String earlyDepartureRequest =
      '${EndPoints.baseUrl}/employee/attendance/early-departure/request';
}
