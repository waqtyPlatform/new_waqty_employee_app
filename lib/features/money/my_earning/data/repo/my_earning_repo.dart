import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/data/services/my_earning_service.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class MyEarningRepo {
  final MyEarningService service;

  const MyEarningRepo(this.service);

  Future<Either<Failure, EmployeeMoneyPreviewModel>> getPreview({
    required String month,
    required String languageCode,
  }) async {
    try {
      return Right(
        await service.getPreview(month: month, languageCode: languageCode),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(ServerFailure(message: 'Invalid server response'));
    }
  }

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
