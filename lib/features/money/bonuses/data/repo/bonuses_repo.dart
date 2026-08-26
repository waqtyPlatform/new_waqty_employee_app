import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/data/services/bonuses_service.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class BonusesRepo {
  final BonusesService service;

  const BonusesRepo(this.service);

  Future<Either<Failure, MoneyBonusResponse>> getBonuses({
    required String languageCode,
    int page = 1,
  }) async {
    try {
      return Right(
        await service.getBonuses(languageCode: languageCode, page: page),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(ServerFailure(message: 'Invalid server response'));
    }
  }
}
