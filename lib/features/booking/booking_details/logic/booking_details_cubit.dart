import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_addable_items_response_model.dart';
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
  String? addingItemKey;
  String? updatingVisitUuid;
  String? updatingItemUuid;
  String? reviewingVisitUuid;
  String lastErrorMessage = '';
  List<ServiceWithPriceModel> servicesWithPrices = [];
  int servicesWithPricesCurrentPage = 1;
  int servicesWithPricesLastPage = 1;
  bool isServicesWithPricesLoading = false;
  bool isServicesWithPricesPaginationLoading = false;
  BookingAddableItemsDataModel? addableItems;
  String? addableItemsVisitUuid;
  bool isAddableItemsLoading = false;

  void getBookingDetails(String uuid) {
    if (uuid.isEmpty) {
      emit(OnBookingDetailsErrorState());
      return;
    }
    emit(OnBookingDetailsLoadingState());
    _bookingDetailsRepo
        .getBookingDetails(uuid)
        .then((value) {
          value.fold(
            (failure) {
              lastErrorMessage = failure.message;
              emit(OnBookingDetailsErrorState(message: failure.message));
            },
            (response) {
              bookingDetails = response.data;
              emit(OnBookingDetailsSuccessState());
            },
          );
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
              lastErrorMessage = failure.message;
              emit(OnBookingDetailsErrorState(message: failure.message));
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
              lastErrorMessage = failure.message;
              emit(OnBookingDetailsErrorState(message: failure.message));
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

  void getAddableItems({required String visitUuid, bool refresh = false}) {
    final bookingUuid = bookingDetails?.uuid ?? '';
    if (bookingUuid.isEmpty || visitUuid.isEmpty) return;
    if (isAddableItemsLoading) return;
    if (!refresh &&
        addableItemsVisitUuid == visitUuid &&
        addableItems != null) {
      return;
    }

    isAddableItemsLoading = true;
    addableItemsVisitUuid = visitUuid;
    emit(OnAddableItemsLoadingState());
    _bookingDetailsRepo
        .getAddableItems(bookingUuid: bookingUuid, visitUuid: visitUuid)
        .then((value) {
          value.fold(
            (failure) {
              isAddableItemsLoading = false;
              lastErrorMessage = failure.message;
              emit(OnAddableItemsErrorState());
            },
            (response) {
              addableItems = response.data;
              addableItemsVisitUuid = response.data.visitUuid.isNotEmpty
                  ? response.data.visitUuid
                  : visitUuid;
              isAddableItemsLoading = false;
              emit(OnAddableItemsSuccessState());
            },
          );
        })
        .catchError((error) {
          isAddableItemsLoading = false;
          emit(OnAddableItemsErrorState());
        });
  }

  void addServiceToBooking(ServiceWithPriceModel service, {String? visitUuid}) {
    addServiceUuidToBooking(
      serviceUuid: service.uuid,
      visitUuid: visitUuid,
      loadingKey: service.uuid,
    );
  }

  void addServiceUuidToBooking({
    required String serviceUuid,
    String? visitUuid,
    String? loadingKey,
  }) {
    final uuid = bookingDetails?.uuid ?? '';
    if (uuid.isEmpty || isAddingService) return;
    if (visitUuid?.isNotEmpty == true) {
      addBookingItemToVisit(
        visitUuid: visitUuid!,
        itemType: 'normal_service',
        serviceUuid: serviceUuid,
        loadingKey: loadingKey ?? serviceUuid,
      );
      return;
    }
    isAddingService = true;
    addingItemKey = loadingKey ?? serviceUuid;
    emit(OnAddBookingServiceLoadingState());
    _bookingDetailsRepo
        .addService(uuid: uuid, serviceUuid: serviceUuid, visitUuid: visitUuid)
        .then((value) {
          value.fold(
            (failure) {
              isAddingService = false;
              addingItemKey = null;
              lastErrorMessage = failure.message;
              emit(OnAddBookingServiceErrorState(message: failure.message));
            },
            (response) {
              bookingDetails = response.data;
              isAddingService = false;
              addingItemKey = null;
              emit(OnAddBookingServiceSuccessState());
              getBookingDetails(uuid);
              if (visitUuid?.isNotEmpty == true) {
                getAddableItems(visitUuid: visitUuid!, refresh: true);
              }
            },
          );
        })
        .catchError((error) {
          isAddingService = false;
          addingItemKey = null;
          lastErrorMessage = error.toString();
          emit(OnAddBookingServiceErrorState(message: lastErrorMessage));
        });
  }

  void addBookingItemToVisit({
    required String visitUuid,
    required String itemType,
    String? serviceUuid,
    String? packageUuid,
    String? packagePurchaseUuid,
    String? followUpUuid,
    int quantity = 1,
    String? bookingMode,
    String? loadingKey,
  }) {
    final uuid = bookingDetails?.uuid ?? '';
    if (uuid.isEmpty ||
        visitUuid.isEmpty ||
        itemType.isEmpty ||
        isAddingService) {
      return;
    }
    isAddingService = true;
    addingItemKey =
        loadingKey ??
        _bookingItemLoadingKey(
          itemType: itemType,
          serviceUuid: serviceUuid,
          packageUuid: packageUuid,
          packagePurchaseUuid: packagePurchaseUuid,
          followUpUuid: followUpUuid,
        );
    emit(OnAddBookingServiceLoadingState());
    _bookingDetailsRepo
        .addBookingItem(
          uuid: uuid,
          visitUuid: visitUuid,
          itemType: itemType,
          serviceUuid: serviceUuid,
          packageUuid: packageUuid,
          packagePurchaseUuid: packagePurchaseUuid,
          followUpUuid: followUpUuid,
          quantity: quantity,
          bookingMode: bookingMode,
        )
        .then((value) {
          value.fold(
            (failure) {
              isAddingService = false;
              addingItemKey = null;
              lastErrorMessage = failure.message;
              emit(OnAddBookingServiceErrorState(message: failure.message));
            },
            (response) {
              bookingDetails = response.data;
              isAddingService = false;
              addingItemKey = null;
              emit(OnAddBookingServiceSuccessState());
              getBookingDetails(uuid);
              getAddableItems(visitUuid: visitUuid, refresh: true);
            },
          );
        })
        .catchError((error) {
          isAddingService = false;
          addingItemKey = null;
          lastErrorMessage = error.toString();
          emit(OnAddBookingServiceErrorState(message: lastErrorMessage));
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

  void endBookingItem(String itemUuid, {int? unitsConsumed}) {
    runBookingItemAction(
      itemUuid: itemUuid,
      action: BookingItemAction.end,
      unitsConsumed: unitsConsumed,
    );
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
              lastErrorMessage = failure.message;
              emit(OnBookingDetailsErrorState(message: failure.message));
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
    int? unitsConsumed,
  }) {
    final bookingUuid = bookingDetails?.uuid ?? '';
    if (bookingUuid.isEmpty || itemUuid.isEmpty || updatingItemUuid != null) {
      return;
    }
    updatingItemUuid = itemUuid;
    emit(OnBookingItemActionLoadingState());
    _bookingDetailsRepo
        .runBookingItemAction(
          itemUuid: itemUuid,
          action: action,
          unitsConsumed: unitsConsumed,
        )
        .then((value) {
          value.fold(
            (failure) {
              updatingItemUuid = null;
              lastErrorMessage = failure.message;
              emit(OnBookingDetailsErrorState(message: failure.message));
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
              lastErrorMessage = failure.message;
              emit(OnBookingDetailsErrorState(message: failure.message));
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

  bool get hasInsufficientUsageBalanceError {
    final message = lastErrorMessage.toUpperCase();
    return message.contains('INSUFFICIENT_USAGE_BALANCE') ||
        message.contains('INSUFFICIENT BALANCE') ||
        lastErrorMessage.contains('الرصيد غير كاف');
  }

  String _bookingItemLoadingKey({
    required String itemType,
    String? serviceUuid,
    String? packageUuid,
    String? packagePurchaseUuid,
    String? followUpUuid,
  }) {
    return [
      itemType,
      packageUuid,
      packagePurchaseUuid,
      followUpUuid,
      serviceUuid,
    ].where((value) => value?.isNotEmpty == true).join(':');
  }

  static BookingDetailsCubit get(dynamic context) => BlocProvider.of(context);
}
