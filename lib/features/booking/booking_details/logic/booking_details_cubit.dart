import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_details_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/services_with_prices_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/repo/booking_details_repo.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_state.dart';

class BookingDetailsCubit extends Cubit<BookingDetailsState> {
  final BookingDetailsRepo _bookingDetailsRepo;

  BookingDetailsCubit(this._bookingDetailsRepo)
    : super(BookingDetailsInitialState());

  BookingDetailsModel? bookingDetails;
  bool isUpdatingStatus = false;
  List<ServiceWithPriceModel> servicesWithPrices = [];
  int servicesWithPricesCurrentPage = 1;
  int servicesWithPricesLastPage = 1;
  bool isServicesWithPricesLoading = false;
  bool isServicesWithPricesPaginationLoading = false;

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

  Future<void> refreshBookingDetails() async {
    final uuid = bookingDetails?.uuid ?? '';
    if (uuid.isEmpty) return;
    getBookingDetails(uuid);
  }

  void markBookingAsNoShow() {
    final uuid = bookingDetails?.uuid ?? '';
    if (uuid.isEmpty || isUpdatingStatus) return;

    isUpdatingStatus = true;
    emit(OnBookingDetailsStatusLoadingState());
    _bookingDetailsRepo
        .updateBookingStatus(uuid: uuid, status: 'completed')
        .then((value) {
          value.fold(
            (failure) {
              isUpdatingStatus = false;
              emit(OnBookingDetailsErrorState());
            },
            (response) {
              bookingDetails = response.data;
              isUpdatingStatus = false;
              emit(OnBookingDetailsStatusSuccessState());
              getBookingDetails(uuid);
            },
          );
        })
        .catchError((error) {
          isUpdatingStatus = false;
          emit(OnBookingDetailsCatchErrorState());
        });
  }

  void getServicesWithPrices({bool refresh = false}) {
    if (refresh) {
      servicesWithPricesCurrentPage = 1;
      servicesWithPricesLastPage = 1;
      servicesWithPrices = [];
      isServicesWithPricesLoading = true;
      emit(OnServicesWithPricesLoadingState());
    } else {
      if (servicesWithPricesCurrentPage >= servicesWithPricesLastPage ||
          isServicesWithPricesLoading ||
          isServicesWithPricesPaginationLoading) {
        return;
      }
      servicesWithPricesCurrentPage++;
      isServicesWithPricesPaginationLoading = true;
      emit(OnServicesWithPricesPaginationLoadingState());
    }

    _bookingDetailsRepo
        .getServicesWithPrices(servicesWithPricesCurrentPage)
        .then((value) {
          value.fold(
            (failure) {
              isServicesWithPricesLoading = false;
              isServicesWithPricesPaginationLoading = false;
              emit(OnBookingDetailsErrorState());
            },
            (response) {
              if (refresh) {
                servicesWithPrices = response.data;
              } else {
                servicesWithPrices.addAll(response.data);
              }
              servicesWithPricesLastPage = response.meta.pagination.lastPage;
              isServicesWithPricesLoading = false;
              isServicesWithPricesPaginationLoading = false;
              emit(
                refresh
                    ? OnServicesWithPricesSuccessState()
                    : OnServicesWithPricesPaginationSuccessState(),
              );
            },
          );
        })
        .catchError((error) {
          isServicesWithPricesLoading = false;
          isServicesWithPricesPaginationLoading = false;
          emit(OnBookingDetailsCatchErrorState());
        });
  }

  static BookingDetailsCubit get(dynamic context) => BlocProvider.of(context);
}
