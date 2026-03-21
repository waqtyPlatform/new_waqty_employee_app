import 'package:new_waqty_employee_app/core/api/api_consumer.dart';

class MyBookingService {
  ApiConsumer apiConsumer;

  MyBookingService({required this.apiConsumer});

  // Example Method
  // Future<dynamic> getMyBookings() async {
  //   final response = await apiConsumer.get(MyBookingApiEndPoints.getMyBookings, null);
  //   return response;
  // }
}
