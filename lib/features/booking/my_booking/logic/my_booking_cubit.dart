import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/data/models/my_booking_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/data/repo/my_booking_repo.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/logic/my_booking_state.dart';

class MyBookingCubit extends Cubit<MyBookingState> {
  final MyBookingRepo _myBookingRepo;

  MyBookingCubit(this._myBookingRepo) : super(InitialState());

  int selectedDayIndex = 0;
  int selectedTabIndex = 0;
  bool isTimelineView = false;

  final ScrollController bookingsScrollController = ScrollController();
  List<MyBookingModel> bookings = [];
  int bookingsCurrentPage = 1;
  int bookingsLastPage = 1;
  bool isBookingsLoading = false;
  bool isBookingsPaginationLoading = false;

  String get selectedStatus {
    switch (selectedTabIndex) {
      case 1:
        return 'completed';
      case 2:
        return 'cancelled';
      default:
        return 'confirmed';
    }
  }

  String get selectedBookingDate {
    final date = DateTime.now().add(Duration(days: selectedDayIndex));
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void init() {
    getMyBookings(refresh: true);
  }

  @override
  Future<void> close() {
    bookingsScrollController.dispose();
    return super.close();
  }

  void changeSelectedDay(int index) {
    selectedDayIndex = index;
    getMyBookings(refresh: true);
  }

  void changeSelectedTab(int index) {
    selectedTabIndex = index;
    getMyBookings(refresh: true);
  }

  void changeViewMode({required bool timeline}) {
    isTimelineView = timeline;
    emit(OnMyBookingViewModeChangedState());
  }

  void onBookingsScrollEnd() {
    if (bookingsCurrentPage >= bookingsLastPage ||
        isBookingsLoading ||
        isBookingsPaginationLoading) {
      return;
    }
    bookingsCurrentPage++;
    getMyBookings();
  }

  void getMyBookings({bool refresh = false}) {
    if (refresh) {
      bookingsCurrentPage = 1;
      bookingsLastPage = 1;
      bookings = [];
      isBookingsLoading = true;
      emit(OnMyBookingLoadingState());
    } else {
      isBookingsPaginationLoading = true;
      emit(OnMyBookingPaginationLoadingState());
    }

    _myBookingRepo
        .getMyBookings(
          status: selectedStatus,
          bookingDate: selectedBookingDate,
          page: bookingsCurrentPage,
        )
        .then((value) {
          value.fold(
            (failure) {
              isBookingsLoading = false;
              isBookingsPaginationLoading = false;
              emit(OnMyBookingErrorState());
            },
            (response) {
              if (refresh) {
                bookings = response.data;
              } else {
                bookings.addAll(response.data);
              }
              bookingsLastPage = response.meta.pagination.lastPage;
              isBookingsLoading = false;
              isBookingsPaginationLoading = false;
              emit(
                refresh
                    ? OnMyBookingSuccessState()
                    : OnMyBookingPaginationSuccessState(),
              );
            },
          );
        })
        .catchError((error) {
          isBookingsLoading = false;
          isBookingsPaginationLoading = false;
          emit(OnMyBookingCatchErrorState());
        });
  }

  static MyBookingCubit get(dynamic context) => BlocProvider.of(context);
}
