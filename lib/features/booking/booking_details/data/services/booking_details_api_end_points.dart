import 'package:new_waqty_employee_app/core/api/end_points.dart';

class BookingDetailsApiEndPoints {
  static String getBookingDetails(String uuid) {
    return '${EndPoints.baseUrl}/api/employee/bookings/$uuid';
  }

  static String updateBookingStatus(String uuid) {
    return '${EndPoints.baseUrl}/api/employee/bookings/$uuid/status';
  }

  static String startBooking(String uuid) {
    return '${EndPoints.baseUrl}/api/employee/bookings/$uuid/start';
  }

  static String completeBooking(String uuid) {
    return '${EndPoints.baseUrl}/api/employee/bookings/$uuid/complete';
  }

  static String markNoShow(String uuid) {
    return '${EndPoints.baseUrl}/api/employee/bookings/$uuid/no-show';
  }

  static String cancelBooking(String uuid) {
    return '${EndPoints.baseUrl}/api/employee/bookings/$uuid/cancel';
  }

  static String getServicesWithPrices(String uuid, int page) {
    return '${EndPoints.baseUrl}/api/employee/bookings/$uuid/available-services?page=$page';
  }

  static String getAddableItems({
    required String bookingUuid,
    required String visitUuid,
  }) {
    return '${EndPoints.baseUrl}/api/employee/bookings/$bookingUuid/visits/$visitUuid/addable-items';
  }

  static String addService(String uuid) {
    return '${EndPoints.baseUrl}/api/employee/bookings/$uuid/services';
  }

  static String addBookingItem(String uuid) {
    return '${EndPoints.baseUrl}/api/employee/bookings/$uuid/items';
  }

  static String checkInVisit(String visitUuid) {
    return '${EndPoints.baseUrl}/api/employee/booking-visits/$visitUuid/check-in';
  }

  static String visitNoShow(String visitUuid) {
    return '${EndPoints.baseUrl}/api/employee/booking-visits/$visitUuid/no-show';
  }

  static String cancelVisit(String visitUuid) {
    return '${EndPoints.baseUrl}/api/employee/booking-visits/$visitUuid/cancel';
  }

  static String visitCustomerReview(String visitUuid) {
    return '${EndPoints.baseUrl}/api/employee/booking-visits/$visitUuid/customer-review';
  }

  static String startBookingItem(String itemUuid) {
    return '${EndPoints.baseUrl}/api/employee/booking-items/$itemUuid/start';
  }

  static String endBookingItem(String itemUuid) {
    return '${EndPoints.baseUrl}/api/employee/booking-items/$itemUuid/end';
  }
}
