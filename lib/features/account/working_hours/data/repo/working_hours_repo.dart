import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/models/working_hours_response_model.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/services/working_hours_service.dart';

class WorkingHoursRepo {
  final WorkingHoursService _workingHoursService;

  WorkingHoursRepo(this._workingHoursService);

  Future<Either<Failure, WorkingHoursResponseModel>> getWorkingHours(
    int page,
  ) async {
    try {
      return Right(await _workingHoursService.getWorkingHours(page));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
