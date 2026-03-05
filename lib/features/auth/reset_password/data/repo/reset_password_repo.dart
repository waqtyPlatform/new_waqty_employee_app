import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/data/models/reset_password_request_model.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/data/services/reset_password_service.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/data/models/reset_password_response_model.dart';

class ResetPasswordRepo {
  final ResetPasswordService _resetPasswordService;

  ResetPasswordRepo(this._resetPasswordService);

  Future<Either<Failure, ResetPasswordResponseModel>> resetPassword(
    ResetPasswordRequestModel parameter,
  ) async {
    try {
      return Right(await _resetPasswordService.resetPassword(parameter));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
