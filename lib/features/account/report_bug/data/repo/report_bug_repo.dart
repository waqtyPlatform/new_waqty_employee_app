import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/data/models/report_bug_response_model.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/data/services/report_bug_service.dart';

class ReportBugRepo {
  final ReportBugService _reportBugService;

  ReportBugRepo(this._reportBugService);

  Future<Either<Failure, ReportBugResponseModel>> sendBugReport({
    required String category,
    required String description,
    required String stepsToReproduce,
    required String languageCode,
  }) async {
    try {
      return Right(
        await _reportBugService.sendBugReport(
          category: category,
          description: description,
          stepsToReproduce: stepsToReproduce,
          languageCode: languageCode,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
