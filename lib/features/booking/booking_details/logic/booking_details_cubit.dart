import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_details_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/repo/booking_details_repo.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_state.dart';

class BookingDetailsCubit extends Cubit<BookingDetailsState> {
  final BookingDetailsRepo _bookingDetailsRepo;

  BookingDetailsCubit(this._bookingDetailsRepo)
    : super(BookingDetailsInitialState());

  BookingDetailsModel? bookingDetails;

  void getBookingDetails(String uuid) {
    if (uuid.isEmpty) {
      emit(OnBookingDetailsErrorState());
      return;
    }
    emit(OnBookingDetailsLoadingState());
    _bookingDetailsRepo
        .getBookingDetails(uuid)
        .then((value) {
          value.fold((failure) => emit(OnBookingDetailsErrorState()), (
            response,
          ) {
            bookingDetails = response.data;
            emit(OnBookingDetailsSuccessState());
          });
        })
        .catchError((error) {
          emit(OnBookingDetailsCatchErrorState());
        });
  }

  static BookingDetailsCubit get(dynamic context) => BlocProvider.of(context);
}
