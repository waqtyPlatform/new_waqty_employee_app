import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/features/notifications/data/services/notification_center_service.dart';
import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/core/utils/app_language.dart';
import 'package:new_waqty_employee_app/features/notifications/data/models/notification_inbox_group_model.dart';
import 'package:new_waqty_employee_app/features/notifications/data/repo/notifications_repo.dart';
import 'package:new_waqty_employee_app/features/notifications/logic/notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepo _repo;

  NotificationsCubit(this._repo) : super(NotificationsInitialState());

  final ScrollController scrollController = ScrollController();
  VoidCallback? _inboxRefreshListener;
  List<NotificationInboxItemModel> notifications = [];
  String status = 'all';
  int currentPage = 1;
  int lastPage = 1;
  int unreadCount = 0;
  bool isLoading = false;
  bool isPaginationLoading = false;
  String languageCode = AppLanguage.currentCode;

  void init({String? languageCode}) {
    if (languageCode != null) this.languageCode = languageCode;
    scrollController.addListener(_onScroll);
    final centerService = getIt<NotificationCenterService>();
    _inboxRefreshListener = () => refresh();
    centerService.inboxRefreshTick.addListener(_inboxRefreshListener!);
    loadNotifications(refresh: true);
    refreshUnreadCount();
  }

  @override
  Future<void> close() {
    scrollController.removeListener(_onScroll);
    final listener = _inboxRefreshListener;
    if (listener != null && getIt.isRegistered<NotificationCenterService>()) {
      getIt<NotificationCenterService>().inboxRefreshTick.removeListener(
        listener,
      );
    }
    scrollController.dispose();
    return super.close();
  }

  void changeStatus(String value) {
    if (status == value) return;
    status = value;
    emit(NotificationsFilterChangedState());
    loadNotifications(refresh: true);
  }

  Future<void> refresh() async {
    await loadNotifications(refresh: true, showLoading: false);
    await refreshUnreadCount();
  }

  Future<void> loadNotifications({
    bool refresh = false,
    bool showLoading = true,
  }) async {
    if (refresh) {
      currentPage = 1;
      lastPage = 1;
      if (showLoading) {
        isLoading = true;
        emit(NotificationsLoadingState());
      }
    } else {
      if (currentPage >= lastPage || isLoading || isPaginationLoading) return;
      currentPage++;
      isPaginationLoading = true;
      emit(NotificationsPaginationLoadingState());
    }

    final result = await _repo.getNotifications(
      languageCode: languageCode,
      status: status,
      page: currentPage,
    );

    result.fold(
      (failure) {
        isLoading = false;
        isPaginationLoading = false;
        emit(NotificationsErrorState(message: failure.message));
      },
      (response) {
        notifications = refresh
            ? response.data
            : [...notifications, ...response.data];
        lastPage = response.pagination.lastPage;
        isLoading = false;
        isPaginationLoading = false;
        emit(
          refresh
              ? NotificationsSuccessState()
              : NotificationsPaginationSuccessState(),
        );
      },
    );
  }

  Future<void> refreshUnreadCount() async {
    final result = await _repo.getUnreadCount(languageCode: languageCode);
    result.fold((_) {}, (response) {
      unreadCount = response.count;
      getIt<NotificationCenterService>().setUnreadCount(unreadCount);
      emit(NotificationsUnreadCountChangedState());
    });
  }

  Future<NotificationInboxItemModel> markRead(
    NotificationInboxItemModel item,
  ) async {
    if (item.uuid.isEmpty || !item.isUnread) return item;
    final result = await _repo.markRead(
      uuid: item.uuid,
      languageCode: languageCode,
    );
    var updatedItem = item;
    result.fold((_) {}, (_) {
      updatedItem = _readCopy(item);
      notifications = notifications.map((notification) {
        if (notification.uuid != item.uuid) return notification;
        return _readCopy(notification);
      }).toList();
      if (unreadCount > 0) unreadCount--;
      getIt<NotificationCenterService>().setUnreadCount(unreadCount);
      emit(NotificationsReadStateChanged());
    });
    return updatedItem;
  }

  Future<void> markAllRead() async {
    final result = await _repo.markAllRead(languageCode: languageCode);
    result.fold((_) {}, (_) {
      notifications = notifications.map((notification) {
        return NotificationInboxItemModel(
          uuid: notification.uuid,
          type: notification.type,
          eventType: notification.eventType,
          category: notification.category,
          title: notification.title,
          message: notification.message,
          time: notification.time,
          createdAt: notification.createdAt,
          actionLabel: notification.actionLabel,
          isUnread: false,
          action: notification.action,
          entity: notification.entity,
          data: notification.data,
          icon: notification.icon,
          iconColor: notification.iconColor,
          backgroundColor: notification.backgroundColor,
        );
      }).toList();
      unreadCount = 0;
      getIt<NotificationCenterService>().setUnreadCount(0);
      emit(NotificationsReadStateChanged());
    });
  }

  void clearAccountState() {
    notifications = [];
    unreadCount = 0;
    getIt<NotificationCenterService>().clearAccountState();
    emit(NotificationsReadStateChanged());
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 120) {
      loadNotifications();
    }
  }

  static NotificationsCubit get(BuildContext context) =>
      BlocProvider.of(context);
}

NotificationInboxItemModel _readCopy(NotificationInboxItemModel notification) {
  return NotificationInboxItemModel(
    uuid: notification.uuid,
    type: notification.type,
    eventType: notification.eventType,
    category: notification.category,
    title: notification.title,
    message: notification.message,
    time: notification.time,
    createdAt: notification.createdAt,
    actionLabel: notification.actionLabel,
    isUnread: false,
    action: notification.action,
    entity: notification.entity,
    data: notification.data,
    icon: notification.icon,
    iconColor: notification.iconColor,
    backgroundColor: notification.backgroundColor,
  );
}
