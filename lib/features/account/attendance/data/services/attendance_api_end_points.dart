import 'package:new_waqty_employee_app/core/api/end_points.dart';

class AttendanceApiEndPoints {
  const AttendanceApiEndPoints._();

  static String getAttendance({
    required String dateFrom,
    required String dateTo,
  }) {
    final month = dateFrom.length >= 7 ? dateFrom.substring(0, 7) : dateFrom;
    return '${EndPoints.baseUrl}/api/employee/attendance?month=$month&date_from=$dateFrom&date_to=$dateTo';
  }
}
