import 'package:new_waqty_employee_app/core/api/end_points.dart';

class WorkingHoursApiEndPoints {
  static String getWorkingHours(int page ) => "${EndPoints.baseUrl}api/employee/shifts";
}
