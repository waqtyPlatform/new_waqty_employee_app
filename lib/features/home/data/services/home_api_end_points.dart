import 'package:new_waqty_employee_app/core/api/end_points.dart';

class HomeApiEndPoints {
  static String todayVisits({
    required String tab,
    required String bookingDate,
    int perPage = 20,
  }) {
    return '${EndPoints.baseUrl}/api/employee/booking-visits?tab=$tab&booking_date=$bookingDate&per_page=$perPage&page=1';
  }

  static String revenue({
    required String startDate,
    required String endDate,
  }) {
    return '${EndPoints.baseUrl}/api/employee/revenue?start_date=$startDate&end_date=$endDate';
  }

  static String ratings({int perPage = 100}) {
    return '${EndPoints.baseUrl}/api/employee/ratings?per_page=$perPage';
  }

  /// The home header needs the name/branch too. Kept local instead of reaching
  /// into the profile feature so the two stay independent.
  static const String profile = '${EndPoints.baseUrl}/api/employee/auth/me';
}
