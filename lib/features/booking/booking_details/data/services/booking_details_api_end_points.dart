import 'package:new_waqty_employee_app/core/api/end_points.dart';

class BookingDetailsApiEndPoints {
  static String getBookingDetails(String uuid) {
    return '${EndPoints.baseUrl}/api/employee/bookings/$uuid';
  }
}
