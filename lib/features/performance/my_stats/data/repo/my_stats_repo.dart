import 'package:new_waqty_employee_app/features/performance/my_stats/data/services/my_stats_service.dart';

class MyStatsRepo {
  // ignore: unused_field
  final MyStatsService _myStatsService;

  MyStatsRepo(this._myStatsService);

  // Example Repository method
  // Future<Either<Failure, dynamic>> getMyStats() async {
  //   try {
  //     return Right(await _myStatsService.getMyStats());
  //   } on ServerException catch (failure) {
  //     return Left(ServerFailure(message: failure.serverFailure.message));
  //   }
  // }
}
