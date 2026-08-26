import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/data/services/earning_trend_service.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class EarningTrendRepo {
  final EarningTrendService service;

  const EarningTrendRepo(this.service);

  Future<Either<Failure, MoneyTrendModel>> getTrend({
    required String period,
    required String month,
    required String languageCode,
  }) async {
    try {
      return Right(
        await service.getTrend(
          period: period,
          month: month,
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
