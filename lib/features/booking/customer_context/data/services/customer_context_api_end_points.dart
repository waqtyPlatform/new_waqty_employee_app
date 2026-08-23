import 'package:new_waqty_employee_app/core/api/end_points.dart';

class CustomerContextApiEndPoints {
  static String context(String customerUuid) {
    return '${EndPoints.baseUrl}/api/employee/customers/$customerUuid/context';
  }

  static String packages(String customerUuid) {
    return '${EndPoints.baseUrl}/api/employee/customers/$customerUuid/packages';
  }

  static String followUps(String customerUuid) {
    return '${EndPoints.baseUrl}/api/employee/customers/$customerUuid/follow-ups';
  }
}
