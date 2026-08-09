import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_details_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/services_with_prices_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/repo/booking_details_repo.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/services/booking_details_service.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_state.dart';

class BookingDetailsCubit extends Cubit<BookingDetailsState> {
  final BookingDetailsRepo _bookingDetailsRepo;

  BookingDetailsCubit(this._bookingDetailsRepo)
    : super(BookingDetailsInitialState());

  BookingDetailsModel? bookingDetails;
  bool isUpdatingStatus = false;
  bool isAddingService = false;
  String? updatingVisitUuid;
  String? updatingItemUuid;
  String? reviewingVisitUuid;
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
    runBookingAction(BookingDetailsAction.noShow);
  }

  void startBooking() {
    runBookingAction(BookingDetailsAction.start);
  }

  void completeBooking() {
    runBookingAction(BookingDetailsAction.complete);
  }

  void cancelBooking() {
    runBookingAction(BookingDetailsAction.cancel);
  }

  void runBookingAction(BookingDetailsAction action) {
    final uuid = bookingDetails?.uuid ?? '';
    if (uuid.isEmpty || isUpdatingStatus) return;

    isUpdatingStatus = true;
    emit(OnBookingDetailsStatusLoadingState());
    _bookingDetailsRepo
        .runBookingAction(uuid: uuid, action: action)
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
    final uuid = bookingDetails?.uuid ?? '';
    if (uuid.isEmpty) return;
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
        .getServicesWithPrices(uuid, servicesWithPricesCurrentPage)
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

  void addServiceToBooking(ServiceWithPriceModel service, {String? visitUuid}) {
    final uuid = bookingDetails?.uuid ?? '';
    if (uuid.isEmpty || isAddingService) return;
    isAddingService = true;
    emit(OnAddBookingServiceLoadingState());
    _bookingDetailsRepo
        .addService(uuid: uuid, serviceUuid: service.uuid, visitUuid: visitUuid)
        .then((value) {
          value.fold(
            (failure) {
              isAddingService = false;
              emit(OnAddBookingServiceErrorState());
            },
            (response) {
              bookingDetails = response.data;
              isAddingService = false;
              emit(OnAddBookingServiceSuccessState());
              getBookingDetails(uuid);
            },
          );
        })
        .catchError((error) {
          isAddingService = false;
          emit(OnAddBookingServiceErrorState());
        });
  }

  void checkInVisit(String visitUuid) {
    runVisitAction(visitUuid: visitUuid, action: BookingVisitAction.checkIn);
  }

  void markVisitNoShow(String visitUuid) {
    runVisitAction(visitUuid: visitUuid, action: BookingVisitAction.noShow);
  }

  void cancelVisit(String visitUuid) {
    runVisitAction(visitUuid: visitUuid, action: BookingVisitAction.cancel);
  }

  void startBookingItem(String itemUuid) {
    runBookingItemAction(itemUuid: itemUuid, action: BookingItemAction.start);
  }

  void endBookingItem(String itemUuid) {
    runBookingItemAction(itemUuid: itemUuid, action: BookingItemAction.end);
  }

  void runVisitAction({
    required String visitUuid,
    required BookingVisitAction action,
  }) {
    final bookingUuid = bookingDetails?.uuid ?? '';
    if (bookingUuid.isEmpty || visitUuid.isEmpty || updatingVisitUuid != null) {
      return;
    }
    updatingVisitUuid = visitUuid;
    emit(OnBookingVisitActionLoadingState());
    _bookingDetailsRepo
        .runVisitAction(visitUuid: visitUuid, action: action)
        .then((value) {
          value.fold(
            (failure) {
              updatingVisitUuid = null;
              emit(OnBookingDetailsErrorState());
            },
            (_) {
              updatingVisitUuid = null;
              emit(OnBookingVisitActionSuccessState());
              getBookingDetails(bookingUuid);
            },
          );
        })
        .catchError((error) {
          updatingVisitUuid = null;
          emit(OnBookingDetailsCatchErrorState());
        });
  }

  void runBookingItemAction({
    required String itemUuid,
    required BookingItemAction action,
  }) {
    final bookingUuid = bookingDetails?.uuid ?? '';
    if (bookingUuid.isEmpty || itemUuid.isEmpty || updatingItemUuid != null) {
      return;
    }
    updatingItemUuid = itemUuid;
    emit(OnBookingItemActionLoadingState());
    _bookingDetailsRepo
        .runBookingItemAction(itemUuid: itemUuid, action: action)
        .then((value) {
          value.fold(
            (failure) {
              updatingItemUuid = null;
              emit(OnBookingDetailsErrorState());
            },
            (_) {
              updatingItemUuid = null;
              emit(OnBookingItemActionSuccessState());
              getBookingDetails(bookingUuid);
            },
          );
        })
        .catchError((error) {
          updatingItemUuid = null;
          emit(OnBookingDetailsCatchErrorState());
        });
  }

  void submitCustomerReview({
    required String visitUuid,
    required int rating,
    required String comment,
  }) {
    final bookingUuid = bookingDetails?.uuid ?? '';
    if (bookingUuid.isEmpty ||
        visitUuid.isEmpty ||
        reviewingVisitUuid != null) {
      return;
    }

    reviewingVisitUuid = visitUuid;
    emit(OnCustomerReviewLoadingState());
    _bookingDetailsRepo
        .submitCustomerReview(
          visitUuid: visitUuid,
          rating: rating,
          comment: comment,
        )
        .then((value) {
          value.fold(
            (failure) {
              reviewingVisitUuid = null;
              emit(OnBookingDetailsErrorState());
            },
            (_) {
              reviewingVisitUuid = null;
              emit(OnCustomerReviewSuccessState());
              getBookingDetails(bookingUuid);
            },
          );
        })
        .catchError((error) {
          reviewingVisitUuid = null;
          emit(OnBookingDetailsCatchErrorState());
        });
  }

  static BookingDetailsCubit get(dynamic context) => BlocProvider.of(context);
}
