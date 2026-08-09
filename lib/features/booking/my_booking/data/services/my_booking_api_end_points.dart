import 'package:new_waqty_employee_app/core/api/end_points.dart';

class MyBookingApiEndPoints {
  static String getMyBookings({
    required String tab,
    required String bookingDate,
    required int page,
    int perPage = 30,
  }) {
    return '${EndPoints.baseUrl}/api/employee/booking-visits?tab=$tab&booking_date=$bookingDate&per_page=$perPage&page=$page';
  }

  static String cancelVisit(String visitUuid) {
    return '${EndPoints.baseUrl}/api/employee/booking-visits/$visitUuid/cancel';
  }
}
