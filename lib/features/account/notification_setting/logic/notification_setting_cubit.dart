import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/data/models/notification_setting_response_model.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/data/repo/notification_setting_repo.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/logic/notification_setting_state.dart';

class NotificationSettingCubit extends Cubit<NotificationSettingState> {
  final NotificationSettingRepo _notificationSettingRepo;

  NotificationSettingCubit(this._notificationSettingRepo)
    : super(NotificationSettingInitialState());

  NotificationSettingsModel? notificationSettings;
  String? updatingKey;
  String languageCode = AppLanguage.currentCode;
  int _updateVersion = 0;

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
    if (key == NotificationSettingKey.shiftStartReminders) return;

    final requestVersion = ++_updateVersion;
    updatingKey = key;
    notificationSettings = oldSettings.copyWithKey(key, value);
    emit(UpdateNotificationSettingLoadingState(key));

    _notificationSettingRepo
        .updateNotificationSettings(
          body: {key: value},
          languageCode: languageCode,
        )
        .then((response) {
          if (requestVersion != _updateVersion) return;
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
          if (requestVersion != _updateVersion) return;
          notificationSettings = oldSettings;
          updatingKey = null;
          emit(UpdateNotificationSettingCatchErrorState());
        });
  }

  static NotificationSettingCubit get(BuildContext context) =>
      BlocProvider.of(context);
}
