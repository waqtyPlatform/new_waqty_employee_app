import 'package:new_waqty_employee_app/core/api/end_points.dart';

class WorkingHoursApiEndPoints {
  static String getWorkingHours({required int page}) =>
      '${EndPoints.baseUrl}/api/employee/working-hours?per_page=15&page=$page';
}
