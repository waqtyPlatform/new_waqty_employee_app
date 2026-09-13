import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_header_widget.dart';
import 'package:new_waqty_employee_app/features/notifications/data/models/notification_inbox_group_model.dart';

class NotificationDetailsScreen extends StatelessWidget {
  final NotificationInboxItemModel notification;

  const NotificationDetailsScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final date = notification.createdAt;
    final dateText = date == null
        ? notification.time
        : AppDateFormat.dayMonthTime(context, date);

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const AccountSupportHeaderWidget(
              titleKey: 'notificationInbox.detailsTitle',
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 28.h),
                physics: const BouncingScrollPhysics(),
                children: [
                  AccountSupportCardWidget(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _NotificationIcon(notification: notification),
                            horizontalSpace(12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    notification.title,
                                    style:
                                        TextStyles.font16greyColor900Weight600,
                                  ),
                                  if (dateText.trim().isNotEmpty) ...[
                                    verticalSpace(4),
                                    Text(
                                      dateText,
                                      style: TextStyles.font12greyColorA3W400,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (notification.message.trim().isNotEmpty) ...[
                          verticalSpace(18),
                          Text(
                            notification.message,
                            style: TextStyles.font14greyColor500W500.copyWith(
                              height: 1.55,
                              color: AppColors.greyColor700,
                            ),
                          ),
                        ],
                        if (notification.category.trim().isNotEmpty ||
                            notification.eventType.trim().isNotEmpty) ...[
                          verticalSpace(18),
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              if (notification.category.trim().isNotEmpty)
                                _MetaPill(text: notification.category),
                              if (notification.eventType.trim().isNotEmpty)
                                _MetaPill(text: notification.eventType),
                              _MetaPill(
                                text: context.tr(
                                  notification.isUnread
                                      ? 'notificationInbox.unread'
                                      : 'notificationInbox.read',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  final NotificationInboxItemModel notification;

  const _NotificationIcon({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.r,
      height: 42.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: notification.backgroundColor,
      ),
      child: Icon(notification.icon, size: 22.r, color: notification.iconColor),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final String text;

  const _MetaPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.greyColorFA,
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: AppColors.greyColorE5),
      ),
      child: Text(text, style: TextStyles.font10greyColorA3W600),
    );
  }
}
