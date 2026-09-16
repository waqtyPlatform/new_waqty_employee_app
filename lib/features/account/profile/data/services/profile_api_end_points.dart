import 'package:new_waqty_employee_app/core/api/end_points.dart';

class ProfileApiEndPoints {
  static const String getProfile = "${EndPoints.baseUrl}/employee/auth/me";
  static const String currentAttendance =
      "${EndPoints.baseUrl}/employee/attendance/current-session";
  static const String clockIn =
      "${EndPoints.baseUrl}/employee/attendance/clock-in";
  static const String clockOut =
      "${EndPoints.baseUrl}/employee/attendance/clock-out";
  static const String startBreak =
      "${EndPoints.baseUrl}/employee/attendance/break/start";
  static const String endBreak =
      "${EndPoints.baseUrl}/employee/attendance/break/end";
  static const String presenceRespond =
      "${EndPoints.baseUrl}/employee/attendance/presence/respond";
}
