import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/data/models/customer_context_model.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/data/services/customer_context_service.dart';

class CustomerContextRepo {
  final CustomerContextService _service;

  const CustomerContextRepo(this._service);

  Future<Either<Failure, CustomerContextResponseModel>> getCustomerContext({
    required String customerUuid,
    required String languageCode,
  }) async {
    try {
      return Right(
        await _service.getCustomerContext(
          customerUuid: customerUuid,
          languageCode: languageCode,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, CustomerContextResponseModel>> assignPackage({
    required String customerUuid,
    required String packageUuid,
    required String languageCode,
  }) async {
    try {
      return Right(
        await _service.assignPackage(
          customerUuid: customerUuid,
          packageUuid: packageUuid,
          languageCode: languageCode,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
