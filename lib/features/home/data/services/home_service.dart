import 'package:new_waqty_employee_app/core/api/api_consumer.dart';
import 'package:new_waqty_employee_app/features/home/data/services/home_api_end_points.dart';

class HomeService {
  ApiConsumer apiConsumer;

  HomeService({required this.apiConsumer});

  // Example Method
  // Future<dynamic> getHomeData() async {
  //   final response = await apiConsumer.get(HomeApiEndPoints.getHomeData, null);
  //   return response;
  // }
}
