import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/account/my_services/data/models/my_services_response_model.dart';
import 'package:new_waqty_employee_app/features/account/my_services/data/services/my_services_service.dart';

class MyServicesRepo {
  final MyServicesService _myServicesService;

  MyServicesRepo(this._myServicesService);

  Future<Either<Failure, MyServicesResponseModel>> getAllServices(
    int page,
  ) async {
    try {
      return Right(await _myServicesService.getAllServices(page));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
