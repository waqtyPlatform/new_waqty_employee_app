import 'package:new_waqty_employee_app/core/api/end_points.dart';

class EmployeeSearchApiEndPoints {
  static String search({
    required String query,
    required String type,
    int limit = 10,
  }) {
    return Uri.parse('${EndPoints.baseUrl}/api/employee/search')
        .replace(
          queryParameters: {
            'q': query,
            'type': type,
            'limit': limit.toString(),
          },
        )
        .toString();
  }

  static String customerAppointments(String customerUuid, {int perPage = 15}) {
    return Uri.parse(
      '${EndPoints.baseUrl}/api/employee/customers/$customerUuid/appointments',
    ).replace(queryParameters: {'per_page': perPage.toString()}).toString();
  }
}
