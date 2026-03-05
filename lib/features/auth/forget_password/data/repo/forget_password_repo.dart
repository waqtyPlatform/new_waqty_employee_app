import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/data/models/forget_password_request_model.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/data/services/forget_password_service.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/data/models/forget_password_response_model.dart';

class ForgetPasswordRepo {
  final ForgetPasswordService _forgetPasswordService;

  ForgetPasswordRepo(this._forgetPasswordService);

  Future<Either<Failure, ForgetPasswordResponseModel>> forgetPassword(
    ForgetPasswordRequestModel parameter,
  ) async {
    try {
      return Right(await _forgetPasswordService.forgetPassword(parameter));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
