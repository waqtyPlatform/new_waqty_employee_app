import 'package:new_waqty_employee_app/core/api/end_points.dart';

class ProfileApiEndPoints {
  static const String getProfile = "${EndPoints.baseUrl}/api/employee/auth/me";
  static const String currentAttendance =
      "${EndPoints.baseUrl}/api/employee/attendance/current-session";
  static const String clockIn =
      "${EndPoints.baseUrl}/api/employee/attendance/clock-in";
  static const String clockOut =
      "${EndPoints.baseUrl}/api/employee/attendance/clock-out";
  static const String startBreak =
      "${EndPoints.baseUrl}/api/employee/attendance/break/start";
  static const String endBreak =
      "${EndPoints.baseUrl}/api/employee/attendance/break/end";
}
