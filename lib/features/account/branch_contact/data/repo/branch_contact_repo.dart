import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/data/models/branch_contact_response_model.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/data/services/branch_contact_service.dart';

class BranchContactRepo {
  final BranchContactService _branchContactService;

  BranchContactRepo(this._branchContactService);

  Future<Either<Failure, BranchContactResponseModel>> getBranchContact(
    String languageCode,
  ) async {
    try {
      return Right(await _branchContactService.getBranchContact(languageCode));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
