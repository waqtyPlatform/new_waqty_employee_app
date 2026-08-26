import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/money/payslip_details/data/services/payslip_details_service.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class PayslipDetailsRepo {
  final PayslipDetailsService service;

  const PayslipDetailsRepo(this.service);

  Future<Either<Failure, MoneyPayslipDetailModel>> getDetails({
    required String uuid,
    required String languageCode,
  }) async {
    try {
      return Right(
        await service.getDetails(uuid: uuid, languageCode: languageCode),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(ServerFailure(message: 'Invalid server response'));
    }
  }
}
