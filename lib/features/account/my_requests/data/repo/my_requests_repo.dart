import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/account/my_requests/data/services/my_requests_service.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/attendance_session_model.dart';

class MyRequestsRepo {
  final MyRequestsService _myRequestsService;

  MyRequestsRepo(this._myRequestsService);

  Future<Either<Failure, AttendanceCurrentModel>> getCurrentSession({
    required String languageCode,
  }) async {
    try {
      return Right(
        await _myRequestsService.getCurrentSession(languageCode: languageCode),
      );
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    } catch (_) {
      return const Left(ServerFailure(message: 'Invalid server response'));
    }
  }

  Future<Either<Failure, EarlyDepartureModel?>> requestEarlyDeparture({
    required String languageCode,
    required String attendanceSessionUuid,
    required String reason,
  }) async {
    try {
      return Right(
        await _myRequestsService.requestEarlyDeparture(
          languageCode: languageCode,
          attendanceSessionUuid: attendanceSessionUuid,
          reason: reason,
        ),
      );
    } on ServerException catch (failure) {
      return Left(failure.serverFailure);
    } catch (_) {
      return const Left(
        ServerFailure(message: 'Early departure request failed'),
      );
    }
  }
}
