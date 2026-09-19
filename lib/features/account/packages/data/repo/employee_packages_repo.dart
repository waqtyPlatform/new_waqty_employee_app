import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/account/packages/data/models/employee_package_model.dart';
import 'package:new_waqty_employee_app/features/account/packages/data/services/employee_packages_service.dart';

class EmployeePackagesRepo {
  final EmployeePackagesService _service;

  EmployeePackagesRepo(this._service);

  Future<Either<Failure, EmployeePackagesResponseModel>> getPackages({
    required String languageCode,
    required int page,
    int perPage = 15,
    String search = '',
  }) async {
    try {
      return Right(
        await _service.getPackages(
          languageCode: languageCode,
          page: page,
          perPage: perPage,
          search: search,
        ),
      );
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }

  Future<Either<Failure, EmployeePackageDetailsResponseModel>>
  getPackageDetails({
    required String uuid,
    required String languageCode,
  }) async {
    try {
      return Right(
        await _service.getPackageDetails(
          uuid: uuid,
          languageCode: languageCode,
        ),
      );
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    }
  }
}
