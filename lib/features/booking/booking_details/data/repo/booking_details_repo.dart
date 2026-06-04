import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_details_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/services_with_prices_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/services/booking_details_service.dart';

class BookingDetailsRepo {
  final BookingDetailsService _bookingDetailsService;

  BookingDetailsRepo(this._bookingDetailsService);

  Future<Either<Failure, BookingDetailsResponseModel>> getBookingDetails(
    String uuid,
  ) async {
    try {
      return Right(await _bookingDetailsService.getBookingDetails(uuid));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, BookingDetailsResponseModel>> updateBookingStatus({
    required String uuid,
    required String status,
  }) async {
    try {
      return Right(
        await _bookingDetailsService.updateBookingStatus(
          uuid: uuid,
          status: status,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, ServicesWithPricesResponseModel>>
  getServicesWithPrices(int page) async {
    try {
      return Right(await _bookingDetailsService.getServicesWithPrices(page));
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
