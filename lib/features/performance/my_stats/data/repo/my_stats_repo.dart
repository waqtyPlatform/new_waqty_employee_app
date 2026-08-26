import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/models/my_stats_response_model.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/services/my_stats_service.dart';

class MyStatsRepo {
  final MyStatsService _myStatsService;

  MyStatsRepo(this._myStatsService);

  Future<Either<Failure, MyStatsResponseModel>> getPerformance({
    required String period,
    required String languageCode,
  }) async {
    try {
      return Right(
        await _myStatsService.getPerformance(
          period: period,
          languageCode: languageCode,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(ServerFailure(message: 'Invalid server response'));
    }
  }
}
