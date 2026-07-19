import 'package:new_waqty_employee_app/core/api/end_points.dart';

class AttendanceApiEndPoints {
  const AttendanceApiEndPoints._();

  static String getAttendance({
    required String dateFrom,
    required String dateTo,
  }) =>
      '${EndPoints.baseUrl}/api/employee/attendance?date_from=$dateFrom&date_to=$dateTo';
}
