import 'package:new_waqty_employee_app/core/api/api_consumer.dart';

class MyStatsService {
  final ApiConsumer apiConsumer;

  MyStatsService({required this.apiConsumer});

  // Example service call
  // Future<dynamic> getMyStats() async {
  //   var response = await apiConsumer.get(EndPoints.myStats);
  //   return response;
  // }
}
