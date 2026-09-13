import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/features/notifications/data/services/notification_router_service.dart';
import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_header_widget.dart';
import 'package:new_waqty_employee_app/features/notifications/data/models/notification_inbox_group_model.dart';
import 'package:new_waqty_employee_app/features/notifications/logic/notifications_cubit.dart';
import 'package:new_waqty_employee_app/features/notifications/logic/notifications_state.dart';
import 'package:new_waqty_employee_app/features/notifications/ui/widgets/notification_filters_widget.dart';
import 'package:new_waqty_employee_app/features/notifications/ui/widgets/notification_group_widget.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AccountSupportHeaderWidget(
              titleKey: 'notificationInbox.title',
            ),
            verticalSpace(18),
            BlocBuilder<NotificationsCubit, NotificationsState>(
              buildWhen: (previous, current) =>
                  current is NotificationsFilterChangedState ||
                  current is NotificationsReadStateChanged ||
                  current is NotificationsSuccessState ||
                  current is NotificationsUnreadCountChangedState,
              builder: (context, state) {
                final cubit = NotificationsCubit.get(context);
                return NotificationFiltersWidget(
                  selectedStatus: cubit.status,
                  unreadCount: cubit.unreadCount,
                  onAllTap: () => cubit.changeStatus('all'),
                  onUnreadTap: () => cubit.changeStatus('unread'),
                  onMarkAllRead: cubit.markAllRead,
                );
              },
            ),
            verticalSpace(18),
            const Expanded(child: _NotificationsListWidget()),
          ],
        ),
      ),
    );
  }
}

class _NotificationsListWidget extends StatelessWidget {
  const _NotificationsListWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        final cubit = NotificationsCubit.get(context);
        final isInitialLoading =
            state is NotificationsLoadingState && cubit.notifications.isEmpty;
        if (isInitialLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is NotificationsErrorState && cubit.notifications.isEmpty) {
          return _NotificationsErrorWidget(message: state.message);
        }

        if (cubit.notifications.isEmpty) {
          return _NotificationsEmptyWidget(status: cubit.status);
        }

        final groups = _groupNotifications(context, cubit.notifications);
        return RefreshIndicator(
          color: AppColors.greenColor500,
          onRefresh: cubit.refresh,
          child: ListView.separated(
            controller: cubit.scrollController,
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 28.h),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            itemBuilder: (context, index) {
              if (index == groups.length) {
                return cubit.isPaginationLoading
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox.shrink();
              }
              return NotificationGroupWidget(
                group: groups[index],
                onItemTap: (item) => _handleTap(context, item),
              );
            },
            separatorBuilder: (_, _) => verticalSpace(18),
            itemCount: groups.length + 1,
          ),
        );
      },
    );
  }

  Future<void> _handleTap(
    BuildContext context,
    NotificationInboxItemModel item,
  ) async {
    final notification = await NotificationsCubit.get(context).markRead(item);
    await getIt<NotificationRouterService>().handleApiNotification(
      notification,
    );
  }
}

class _NotificationsEmptyWidget extends StatelessWidget {
  final String status;

  const _NotificationsEmptyWidget({required this.status});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: NotificationsCubit.get(context).refresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 240.h),
          Center(
            child: Text(
              context.tr(
                status == 'unread'
                    ? 'notificationInbox.noUnread'
                    : 'notificationInbox.empty',
              ),
              textAlign: TextAlign.center,
              style: TextStyles.font14greyColor500W500,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationsErrorWidget extends StatelessWidget {
  final String message;

  const _NotificationsErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.isEmpty ? context.tr('notificationInbox.error') : message,
              textAlign: TextAlign.center,
              style: TextStyles.font14greyColor500W500,
            ),
            verticalSpace(12),
            TextButton(
              onPressed: () => NotificationsCubit.get(
                context,
              ).loadNotifications(refresh: true),
              child: Text(context.tr('common.retry')),
            ),
          ],
        ),
      ),
    );
  }
}

List<NotificationInboxGroupModel> _groupNotifications(
  BuildContext context,
  List<NotificationInboxItemModel> items,
) {
  final today = <NotificationInboxItemModel>[];
  final yesterday = <NotificationInboxItemModel>[];
  final earlier = <NotificationInboxItemModel>[];
  final now = DateTime.now();
  final todayDate = DateTime(now.year, now.month, now.day);
  final yesterdayDate = todayDate.subtract(const Duration(days: 1));

  for (final item in items) {
    final date = item.createdAt;
    if (date == null) {
      earlier.add(item);
      continue;
    }
    final itemDate = DateTime(date.year, date.month, date.day);
    if (itemDate == todayDate) {
      today.add(item);
    } else if (itemDate == yesterdayDate) {
      yesterday.add(item);
    } else {
      earlier.add(item);
    }
  }

  return [
    if (today.isNotEmpty)
      NotificationInboxGroupModel(
        title: context.tr('notificationInbox.today'),
        items: today,
      ),
    if (yesterday.isNotEmpty)
      NotificationInboxGroupModel(
        title: context.tr('notificationInbox.yesterday'),
        items: yesterday,
      ),
    if (earlier.isNotEmpty)
      NotificationInboxGroupModel(
        title: context.tr('notificationInbox.earlier'),
        items: earlier,
      ),
  ];
}
