import 'package:new_waqty_employee_app/core/api/end_points.dart';

class WorkingHoursApiEndPoints {
  static String getWorkingHours({
    required int page,
    required String dateFrom,
    required String dateTo,
  }) =>
      '${EndPoints.baseUrl}/api/employee/working-hours?date_from=$dateFrom&date_to=$dateTo&per_page=20&page=$page';
}
