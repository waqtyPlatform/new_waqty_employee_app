import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/money/commissions/data/services/commissions_service.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class CommissionsRepo {
  final CommissionsService service;

  const CommissionsRepo(this.service);

  Future<Either<Failure, MoneyCommissionResponse>> getCommissions({
    required String languageCode,
    required String month,
    int page = 1,
  }) async {
    try {
      return Right(
        await service.getCommissions(
          languageCode: languageCode,
          month: month,
          page: page,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(ServerFailure(message: 'Invalid server response'));
    }
  }
}
