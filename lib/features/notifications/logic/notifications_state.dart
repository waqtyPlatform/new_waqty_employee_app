abstract class NotificationsState {}

class NotificationsInitialState extends NotificationsState {}

class NotificationsLoadingState extends NotificationsState {}

class NotificationsSuccessState extends NotificationsState {}

class NotificationsPaginationLoadingState extends NotificationsState {}

class NotificationsPaginationSuccessState extends NotificationsState {}

class NotificationsErrorState extends NotificationsState {
  final String message;

  NotificationsErrorState({this.message = ''});
}

class NotificationsFilterChangedState extends NotificationsState {}

class NotificationsReadStateChanged extends NotificationsState {}

class NotificationsUnreadCountChangedState extends NotificationsState {}
