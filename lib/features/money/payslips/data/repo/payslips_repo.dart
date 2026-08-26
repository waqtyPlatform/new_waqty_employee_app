import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/money/payslips/data/services/payslips_service.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class PayslipsRepo {
  final PayslipsService service;

  const PayslipsRepo(this.service);

  Future<Either<Failure, MoneyPayslipsResponse>> getPayslips({
    required int page,
    required String languageCode,
  }) async {
    try {
      return Right(
        await service.getPayslips(page: page, languageCode: languageCode),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(ServerFailure(message: 'Invalid server response'));
    }
  }
}
