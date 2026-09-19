import 'package:new_waqty_employee_app/core/api/end_points.dart';

class HomeApiEndPoints {
  static const String home = '${EndPoints.baseUrl}/employee/home';
  static const String todaySnapshot =
      '${EndPoints.baseUrl}/employee/home/today-snapshot';
  static const String todayEarnings =
      '${EndPoints.baseUrl}/employee/home/today-earnings';
  static String upcomingAppointments({int limit = 5}) =>
      '${EndPoints.baseUrl}/employee/home/upcoming-appointments?limit=$limit';
  static const String latestReview =
      '${EndPoints.baseUrl}/employee/home/latest-review';
}
