import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/data/services/daily_earning_details_service.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class DailyEarningDetailsRepo {
  final DailyEarningDetailsService service;

  const DailyEarningDetailsRepo(this.service);

  Future<Either<Failure, DailyMoneyDetailModel>> getDaily({
    required String date,
    required String languageCode,
  }) async {
    try {
      return Right(
        await service.getDaily(date: date, languageCode: languageCode),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(ServerFailure(message: 'Invalid server response'));
    }
  }
}
