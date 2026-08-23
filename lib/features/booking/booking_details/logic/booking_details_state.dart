abstract class BookingDetailsState {}

class BookingDetailsInitialState extends BookingDetailsState {}

class OnBookingDetailsLoadingState extends BookingDetailsState {}

class OnBookingDetailsSuccessState extends BookingDetailsState {}

class OnBookingDetailsStatusLoadingState extends BookingDetailsState {}

class OnBookingDetailsStatusSuccessState extends BookingDetailsState {}

class OnBookingVisitActionLoadingState extends BookingDetailsState {}

class OnBookingVisitActionSuccessState extends BookingDetailsState {}

class OnBookingItemActionLoadingState extends BookingDetailsState {}

class OnBookingItemActionSuccessState extends BookingDetailsState {}

class OnCustomerReviewLoadingState extends BookingDetailsState {}

class OnCustomerReviewSuccessState extends BookingDetailsState {}

class OnServicesWithPricesLoadingState extends BookingDetailsState {}

class OnServicesWithPricesSuccessState extends BookingDetailsState {}

class OnServicesWithPricesPaginationLoadingState extends BookingDetailsState {}

class OnServicesWithPricesPaginationSuccessState extends BookingDetailsState {}

class OnAddableItemsLoadingState extends BookingDetailsState {}

class OnAddableItemsSuccessState extends BookingDetailsState {}

class OnAddableItemsErrorState extends BookingDetailsState {}

class OnAddBookingServiceLoadingState extends BookingDetailsState {}

class OnAddBookingServiceSuccessState extends BookingDetailsState {}

class OnAddBookingServiceErrorState extends BookingDetailsState {
  final String message;

  OnAddBookingServiceErrorState({this.message = ''});
}

class OnBookingDetailsErrorState extends BookingDetailsState {
  final String message;

  OnBookingDetailsErrorState({this.message = ''});
}

class OnBookingDetailsCatchErrorState extends BookingDetailsState {}
