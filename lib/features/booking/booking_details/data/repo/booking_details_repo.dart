import 'package:dartz/dartz.dart';
import 'package:new_waqty_employee_app/core/exceptions/exceptions.dart';
import 'package:new_waqty_employee_app/core/exceptions/failure.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_addable_items_response_model.dart';
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

  Future<Either<Failure, BookingDetailsResponseModel>> runBookingAction({
    required String uuid,
    required BookingDetailsAction action,
  }) async {
    try {
      return Right(
        await _bookingDetailsService.runBookingAction(
          uuid: uuid,
          action: action,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, BookingDetailsResponseModel>> addService({
    required String uuid,
    required String serviceUuid,
    String? visitUuid,
  }) async {
    try {
      return Right(
        await _bookingDetailsService.addService(
          uuid: uuid,
          serviceUuid: serviceUuid,
          visitUuid: visitUuid,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, BookingDetailsResponseModel>> addBookingItem({
    required String uuid,
    required String visitUuid,
    required String itemType,
    String? serviceUuid,
    String? packageUuid,
    String? packagePurchaseUuid,
    String? followUpUuid,
    int quantity = 1,
    String? bookingMode,
  }) async {
    try {
      return Right(
        await _bookingDetailsService.addBookingItem(
          uuid: uuid,
          visitUuid: visitUuid,
          itemType: itemType,
          serviceUuid: serviceUuid,
          packageUuid: packageUuid,
          packagePurchaseUuid: packagePurchaseUuid,
          followUpUuid: followUpUuid,
          quantity: quantity,
          bookingMode: bookingMode,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, ServicesWithPricesResponseModel>>
  getServicesWithPrices(String uuid, int page) async {
    try {
      return Right(
        await _bookingDetailsService.getServicesWithPrices(uuid, page),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, BookingAddableItemsResponseModel>> getAddableItems({
    required String bookingUuid,
    required String visitUuid,
  }) async {
    try {
      return Right(
        await _bookingDetailsService.getAddableItems(
          bookingUuid: bookingUuid,
          visitUuid: visitUuid,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, void>> runVisitAction({
    required String visitUuid,
    required BookingVisitAction action,
  }) async {
    try {
      return Right(
        await _bookingDetailsService.runVisitAction(
          visitUuid: visitUuid,
          action: action,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, void>> runBookingItemAction({
    required String itemUuid,
    required BookingItemAction action,
    int? unitsConsumed,
  }) async {
    try {
      return Right(
        await _bookingDetailsService.runBookingItemAction(
          itemUuid: itemUuid,
          action: action,
          unitsConsumed: unitsConsumed,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }

  Future<Either<Failure, BookingCustomerReviewModel>> submitCustomerReview({
    required String visitUuid,
    required int rating,
    required String comment,
  }) async {
    try {
      return Right(
        await _bookingDetailsService.submitCustomerReview(
          visitUuid: visitUuid,
          rating: rating,
          comment: comment,
        ),
      );
    } on ServerException catch (failure) {
      return Left(ServerFailure(message: failure.serverFailure.message));
    }
  }
}
