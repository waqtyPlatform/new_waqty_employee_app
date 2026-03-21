import 'package:new_waqty_employee_app/features/booking/my_booking/data/services/my_booking_service.dart';

class MyBookingRepo {
  final MyBookingService _myBookingService;

  MyBookingRepo(this._myBookingService);

  // Example Repository method
  // Future<Either<Failure, dynamic>> getMyBookings() async {
  //   try {
  //     return Right(await _myBookingService.getMyBookings());
  //   } on ServerException catch (failure) {
  //     return Left(ServerFailure(message: failure.serverFailure.message));
  //   }
  // }
}
