abstract class NotificationSettingState {}

class NotificationSettingInitialState extends NotificationSettingState {}

class GetNotificationSettingLoadingState extends NotificationSettingState {}

class GetNotificationSettingSuccessState extends NotificationSettingState {}

class GetNotificationSettingErrorState extends NotificationSettingState {}

class GetNotificationSettingCatchErrorState extends NotificationSettingState {}

class UpdateNotificationSettingLoadingState extends NotificationSettingState {
  final String key;

  UpdateNotificationSettingLoadingState(this.key);
}

class UpdateNotificationSettingSuccessState extends NotificationSettingState {}

class UpdateNotificationSettingErrorState extends NotificationSettingState {}

class UpdateNotificationSettingCatchErrorState
    extends NotificationSettingState {}
