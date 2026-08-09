import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/data/models/my_booking_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/data/services/my_booking_service.dart';

class MyBookingRepo {
  final MyBookingService _myBookingService;

  MyBookingRepo(this._myBookingService);

  Future<Either<Failure, MyBookingResponseModel>> getMyBookings({
    required String tab,
    required String bookingDate,
    required int page,
    required String languageCode,
  }) async {
    try {
      return Right(
        await _myBookingService.getMyBookings(
          tab: tab,
          bookingDate: bookingDate,
          page: page,
          languageCode: languageCode,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, void>> cancelVisit({
    required String visitUuid,
    required String languageCode,
  }) async {
    try {
      return Right(
        await _myBookingService.cancelVisit(
          visitUuid: visitUuid,
          languageCode: languageCode,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
