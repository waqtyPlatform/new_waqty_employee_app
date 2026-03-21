import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/repo/booking_details_repo.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_state.dart';

class BookingDetailsCubit extends Cubit<BookingDetailsState> {
  final BookingDetailsRepo _bookingDetailsRepo;

  BookingDetailsCubit(this._bookingDetailsRepo) : super(BookingDetailsInitialState());

  // Example Logic method
  // getBookingDetails() {
  //   emit(OnBookingDetailsLoadingState());
  //   _bookingDetailsRepo.getBookingDetails().then((value) {
  //     value.fold(
  //         (l) => emit(OnBookingDetailsErrorState()),
  //         (r) => emit(OnBookingDetailsSuccessState()));
  //   }).catchError((error) {
  //     emit(OnBookingDetailsCatchErrorState());
  //   });
  // }

  static BookingDetailsCubit get(context) => BlocProvider.of(context);
}
