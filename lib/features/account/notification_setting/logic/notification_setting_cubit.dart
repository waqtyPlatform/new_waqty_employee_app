import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/data/models/notification_setting_response_model.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/data/repo/notification_setting_repo.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/logic/notification_setting_state.dart';

class NotificationSettingCubit extends Cubit<NotificationSettingState> {
  final NotificationSettingRepo _notificationSettingRepo;

  NotificationSettingCubit(this._notificationSettingRepo)
    : super(NotificationSettingInitialState());

  NotificationSettingsModel? notificationSettings;
  String? updatingKey;
  String languageCode = 'en';

  void getNotificationSettings(String languageCode) {
    this.languageCode = languageCode;
    emit(GetNotificationSettingLoadingState());
    _notificationSettingRepo
        .getNotificationSettings(languageCode)
        .then((value) {
          value.fold((failure) => emit(GetNotificationSettingErrorState()), (
            response,
          ) {
            notificationSettings = response.data;
            emit(GetNotificationSettingSuccessState());
          });
        })
        .catchError((error) {
          emit(GetNotificationSettingCatchErrorState());
        });
  }

  void updateNotificationSetting(String key, bool value) {
    final oldSettings = notificationSettings;
    if (oldSettings == null) {
      return;
    }

    updatingKey = key;
    notificationSettings = oldSettings.copyWithKey(key, value);
    emit(UpdateNotificationSettingLoadingState(key));

    _notificationSettingRepo
        .updateNotificationSettings(
          body: notificationSettings!.toJson(),
          languageCode: languageCode,
        )
        .then((response) {
          response.fold(
            (failure) {
              notificationSettings = oldSettings;
              updatingKey = null;
              emit(UpdateNotificationSettingErrorState());
            },
            (successResponse) {
              notificationSettings = successResponse.data;
              updatingKey = null;
              emit(UpdateNotificationSettingSuccessState());
            },
          );
        })
        .catchError((error) {
          notificationSettings = oldSettings;
          updatingKey = null;
          emit(UpdateNotificationSettingCatchErrorState());
        });
  }

  static NotificationSettingCubit get(BuildContext context) =>
      BlocProvider.of(context);
}
