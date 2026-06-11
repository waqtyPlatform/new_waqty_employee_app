import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/data/models/help_questions_response_model.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/data/services/help_questions_service.dart';

class HelpQuestionsRepo {
  final HelpQuestionsService _helpQuestionsService;

  HelpQuestionsRepo(this._helpQuestionsService);

  Future<Either<Failure, HelpQuestionsResponseModel>> getFaqs(
    String languageCode,
  ) async {
    try {
      return Right(await _helpQuestionsService.getFaqs(languageCode));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
