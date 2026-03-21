import 'package:new_waqty_employee_app/core/api/api_consumer.dart';

class BookingDetailsService {
  ApiConsumer apiConsumer;

  BookingDetailsService({required this.apiConsumer});

  // Example Method
  // Future<dynamic> getBookingDetails() async {
  //   final response = await apiConsumer.get(BookingDetailsApiEndPoints.getBookingDetails, null);
  //   return response;
  // }
}
