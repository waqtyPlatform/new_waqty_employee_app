import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/data/repo/my_booking_repo.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/logic/my_booking_state.dart';

class MyBookingCubit extends Cubit<MyBookingState> {
  final MyBookingRepo _myBookingRepo;

  MyBookingCubit(this._myBookingRepo) : super(InitialState());

  int selectedDayIndex = 3;
  int selectedTabIndex = 0;

  void changeSelectedDay(int index) {
    selectedDayIndex = index;
    emit(InitialState());
  }

  void changeSelectedTab(int index) {
    selectedTabIndex = index;
    emit(InitialState());
  }

  // Example Logic method
  // getMyBookings() {
  //   emit(OnMyBookingLoadingState());
  //   _myBookingRepo.getMyBookings().then((value) {
  //     value.fold(
  //         (l) => emit(OnMyBookingErrorState()),
  //         (r) => emit(OnMyBookingSuccessState()));
  //   }).catchError((error) {
  //     emit(OnMyBookingCatchErrorState());
  //   });
  // }

  static MyBookingCubit get(context) => BlocProvider.of(context);
}
