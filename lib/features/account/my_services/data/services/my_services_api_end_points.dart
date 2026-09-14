import 'package:new_waqty_employee_app/core/api/end_points.dart';

class MyServicesApiEndPoints {
  static String getAllServices(int page) =>
      '${EndPoints.baseUrl}/employee/services/all?per_page=20&page=$page';
}
