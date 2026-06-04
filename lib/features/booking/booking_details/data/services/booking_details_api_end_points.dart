import 'package:new_waqty_employee_app/core/api/end_points.dart';

class BookingDetailsApiEndPoints {
  static String getBookingDetails(String uuid) {
    return '${EndPoints.baseUrl}/api/employee/bookings/$uuid';
  }

  static String updateBookingStatus(String uuid) {
    return '${EndPoints.baseUrl}/api/employee/bookings/$uuid/status';
  }

  static String getServicesWithPrices(int page) {
    return '${EndPoints.baseUrl}/api/employee/services/with-prices?page=$page';
  }
}
