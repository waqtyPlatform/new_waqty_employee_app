import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/account/attendance/data/models/attendance_response_model.dart';
import 'package:new_waqty_employee_app/features/account/attendance/data/services/attendance_service.dart';

class AttendanceRepo {
  final AttendanceService _attendanceService;

  AttendanceRepo(this._attendanceService);

  Future<Either<Failure, AttendanceResponseModel>> getAttendance({
    required String dateFrom,
    required String dateTo,
    required String languageCode,
  }) async {
    try {
      return Right(
        await _attendanceService.getAttendance(
          dateFrom: dateFrom,
          dateTo: dateTo,
          languageCode: languageCode,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
