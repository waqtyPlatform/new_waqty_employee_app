import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/data/models/verify_code_request_model.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/data/services/verify_code_service.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/data/models/verify_code_response_model.dart';

class VerifyCodeRepo {
  final VerifyCodeService _verifyCodeService;

  VerifyCodeRepo(this._verifyCodeService);

  Future<Either<Failure, VerifyCodeResponseModel>> verifyCode(
    VerifyCodeRequestModel parameter,
  ) async {
    try {
      return Right(await _verifyCodeService.verifyCode(parameter));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
