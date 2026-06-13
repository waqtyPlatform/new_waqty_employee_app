import 'package:new_waqty_employee_app/core/api/end_points.dart';

class ProfileApiEndPoints {
  static const String getProfile = "${EndPoints.baseUrl}/api/employee/auth/me";
  static const String currentAttendance =
      "${EndPoints.baseUrl}/api/employee/attendance/current";
}
