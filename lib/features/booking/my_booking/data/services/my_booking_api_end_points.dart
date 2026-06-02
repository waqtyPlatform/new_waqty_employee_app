import 'package:new_waqty_employee_app/core/api/end_points.dart';

class MyBookingApiEndPoints {
  static String getMyBookings({
    required String status,
    required String bookingDate,
    required int page,
    int perPage = 30,
  }) {
    return '${EndPoints.baseUrl}/api/employee/bookings?status=$status&booking_date=$bookingDate&per_page=$perPage&page=$page';
  }
}
