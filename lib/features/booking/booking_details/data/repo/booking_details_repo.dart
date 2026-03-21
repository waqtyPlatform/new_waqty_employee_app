import 'package:new_waqty_employee_app/features/booking/booking_details/data/services/booking_details_service.dart';

class BookingDetailsRepo {
  final BookingDetailsService _bookingDetailsService;

  BookingDetailsRepo(this._bookingDetailsService);

  // Example Repository method
  // Future<Either<Failure, dynamic>> getBookingDetails() async {
  //   try {
  //     return Right(await _bookingDetailsService.getBookingDetails());
  //   } on ServerException catch (failure) {
  //     return Left(ServerFailure(message: failure.serverFailure.message));
  //   }
  // }
}
