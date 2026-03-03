import 'package:new_waqty_employee_app/features/home/data/services/home_service.dart';

class HomeRepo {
  final HomeService _homeService;

  HomeRepo(this._homeService);

  // Example Repository method
  // Future<Either<Failure, dynamic>> getHomeData() async {
  //   try {
  //     return Right(await _homeService.getHomeData());
  //   } on ServerException catch (failure) {
  //     return Left(ServerFailure(message: failure.serverFailure.message));
  //   }
  // }
}
