import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/data/models/contact_manager_response_model.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/data/services/contact_manager_service.dart';

class ContactManagerRepo {
  final ContactManagerService _contactManagerService;

  ContactManagerRepo(this._contactManagerService);

  Future<Either<Failure, ContactManagerResponseModel>> sendMessage({
    required String subject,
    required String message,
    required String priority,
    required String languageCode,
  }) async {
    try {
      return Right(
        await _contactManagerService.sendMessage(
          subject: subject,
          message: message,
          priority: priority,
          languageCode: languageCode,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
