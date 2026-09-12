import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/search/data/models/employee_search_models.dart';
import 'package:new_waqty_employee_app/features/search/data/services/employee_search_service.dart';

class EmployeeSearchRepo {
  final EmployeeSearchService _service;

  EmployeeSearchRepo(this._service);

  Future<Either<Failure, EmployeeSearchResponseModel>> search({
    required String query,
    required String type,
    required String languageCode,
  }) async {
    try {
      return Right(
        await _service.search(
          query: query,
          type: type,
          languageCode: languageCode,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    } catch (_) {
      return const Left(ServerFailure(message: 'Invalid server response'));
    }
  }

  Future<Either<Failure, EmployeeCustomerAppointmentsResponseModel>>
  customerAppointments({
    required String customerUuid,
    required String languageCode,
  }) async {
    try {
      return Right(
        await _service.customerAppointments(
          customerUuid: customerUuid,
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
