import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/notifications/data/models/notification_inbox_group_model.dart';

class NotificationCardWidget extends StatelessWidget {
  final NotificationInboxItemModel item;
  final VoidCallback? onTap;

  const NotificationCardWidget({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final actionLabel = item.actionLabel ?? _actionLabel(context, item);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: item.isUnread
                ? AppColors.greenColor500
                : AppColors.greyColor25,
            width: .8.w,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: .05),
              blurRadius: 18.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (item.isUnread)
              PositionedDirectional(
                start: 0,
                top: 0,
                bottom: 0,
                child: Container(width: 3.w, color: AppColors.greenColor500),
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _NotificationIcon(item: item),
                      horizontalSpace(12),
                      Expanded(child: _NotificationContent(item: item)),
                    ],
                  ),
                  if (actionLabel != null) ...[
                    verticalSpace(12),
                    Divider(height: 1.h, color: AppColors.greyColor25),
                    verticalSpace(10),
                    _NotificationAction(
                      label: actionLabel,
                      isUnread: item.isUnread,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String? _actionLabel(BuildContext context, NotificationInboxItemModel item) {
  final screen = item.action.screen;
  if (screen == 'booking_details' || item.category == 'booking') {
    return context.tr('notificationInbox.viewSchedule');
  }
  if (screen == 'employee_schedule' ||
      screen == 'shift_details' ||
      item.type.contains('shift') ||
      item.type.contains('schedule')) {
    return context.tr('notificationInbox.viewSchedule');
  }
  if (screen == 'attendance' || item.type.contains('attendance')) {
    return context.tr('notificationInbox.viewSchedule');
  }
  if (screen == 'notification_details' || item.type.contains('announcement')) {
    return null;
  }
  if (screen == 'bonuses' || item.type.contains('bonus')) {
    return context.tr('notificationInbox.viewBonuses');
  }
  if (screen == 'deductions' || item.type.contains('deduction')) {
    return context.tr('notificationInbox.viewDeductions');
  }
  if (screen == 'payslip_details' || item.type.contains('payslip')) {
    return context.tr('notificationInbox.viewPayslip');
  }
  return null;
}

class _NotificationContent extends StatelessWidget {
  final NotificationInboxItemModel item;

  const _NotificationContent({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.font14greyColor900Weight600,
              ),
            ),
            if (item.isUnread) ...[
              horizontalSpace(6),
              Container(
                width: 7.r,
                height: 7.r,
                decoration: const BoxDecoration(
                  color: AppColors.greenColor500,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
        verticalSpace(4),
        Text(
          item.message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.font12greyColor500W400.copyWith(height: 1.35),
        ),
        verticalSpace(8),
        Text(
          item.createdAt == null
              ? item.time
              : AppDateFormat.relativeDate(context, item.createdAt!),
          style: TextStyles.font10greyColor3003Weight500,
        ),
      ],
    );
  }
}

class _NotificationAction extends StatelessWidget {
  final String label;
  final bool isUnread;

  const _NotificationAction({required this.label, required this.isUnread});

  @override
  Widget build(BuildContext context) {
    final color = isUnread ? AppColors.greenColor500 : AppColors.greyColor500;
    return Row(
      children: [
        Text(
          label,
          style: TextStyles.font12greenColor500W600.copyWith(color: color),
        ),
        horizontalSpace(4),
        Icon(Icons.arrow_forward_ios, color: color, size: 12.r),
      ],
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  final NotificationInboxItemModel item;

  const _NotificationIcon({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        color: item.backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(item.icon, color: item.iconColor, size: 18.r),
    );
  }
}
