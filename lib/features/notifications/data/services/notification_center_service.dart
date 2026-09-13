import 'package:flutter/foundation.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/notifications/data/repo/notifications_repo.dart';

class NotificationCenterService {
  final NotificationsRepo _repo;

  NotificationCenterService(this._repo);

  final ValueNotifier<int> unreadCount = ValueNotifier<int>(0);
  final ValueNotifier<int> inboxRefreshTick = ValueNotifier<int>(0);

  Future<void> refreshUnreadCount({String? languageCode}) async {
    final token = await CacheHelper.getSecuredString(
      ConstantKeys.saveTokenToShared,
    );
    if (token.isEmpty) {
      unreadCount.value = 0;
      return;
    }

    final result = await _repo.getUnreadCount(
      languageCode: languageCode ?? AppLanguage.currentCode,
    );
    result.fold((_) {}, (response) {
      unreadCount.value = response.count;
    });
  }

  void setUnreadCount(int value) {
    unreadCount.value = value < 0 ? 0 : value;
  }

  void notifyInboxShouldRefresh() {
    inboxRefreshTick.value++;
  }

  void clearAccountState() {
    unreadCount.value = 0;
    inboxRefreshTick.value = 0;
  }
}
