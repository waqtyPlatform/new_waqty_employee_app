import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/data/models/notification_setting_response_model.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';

class NotificationSettingListWidget extends StatelessWidget {
  final NotificationSettingsModel settings;
  final String? updatingKey;
  final void Function(String key, bool value) onChanged;

  const NotificationSettingListWidget({
    super.key,
    required this.settings,
    required this.updatingKey,
    required this.onChanged,
  });

  static const List<_NotificationSettingItem> _notificationItems = [
    _NotificationSettingItem(
      apiKey: NotificationSettingKey.newBookingsAssigned,
      titleKey: 'notifications.newBookings',
    ),
    _NotificationSettingItem(
      apiKey: NotificationSettingKey.bookingCancellations,
      titleKey: 'notifications.bookingCancellations',
    ),
    _NotificationSettingItem(
      apiKey: NotificationSettingKey.appointmentReminders,
      titleKey: 'notifications.appointmentReminders',
    ),
    _NotificationSettingItem(
      apiKey: NotificationSettingKey.shiftChanges,
      titleKey: 'notifications.shiftChanges',
    ),
    _NotificationSettingItem(
      apiKey: NotificationSettingKey.shiftStartReminders,
      titleKey: 'notifications.shiftStartReminders',
      helperKey: 'notifications.shiftStartRemindersSoon',
      isEnabled: false,
    ),
    _NotificationSettingItem(
      apiKey: NotificationSettingKey.leaveAndRequestUpdates,
      titleKey: 'notifications.leaveAndRequestUpdates',
    ),
    _NotificationSettingItem(
      apiKey: NotificationSettingKey.managerAnnouncements,
      titleKey: 'notifications.managerAnnouncements',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AccountSupportCardWidget(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: List.generate(_notificationItems.length, (index) {
          final item = _notificationItems[index];
          final value = settings.valueOf(item.apiKey);
          return NotificationSettingItemWidget(
            title: context.tr(item.titleKey),
            helperText: item.helperKey == null
                ? null
                : context.tr(item.helperKey!),
            value: value,
            isLoading: updatingKey == item.apiKey,
            isEnabled: item.isEnabled,
            showDivider: index != _notificationItems.length - 1,
            onTap: updatingKey == null && item.isEnabled
                ? () => onChanged(item.apiKey, !value)
                : null,
          );
        }),
      ),
    );
  }
}

class _NotificationSettingItem {
  final String apiKey;
  final String titleKey;
  final String? helperKey;
  final bool isEnabled;

  const _NotificationSettingItem({
    required this.apiKey,
    required this.titleKey,
    this.helperKey,
    this.isEnabled = true,
  });
}

class NotificationSettingItemWidget extends StatelessWidget {
  final String title;
  final String? helperText;
  final bool value;
  final bool isLoading;
  final bool isEnabled;
  final bool showDivider;
  final VoidCallback? onTap;

  const NotificationSettingItemWidget({
    super.key,
    required this.title,
    this.helperText,
    required this.value,
    required this.isLoading,
    this.isEnabled = true,
    required this.showDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          minHeight: helperText == null ? 46.h : 62.h,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.greyColorF5))
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.font14greyColor900Weight500.copyWith(
                        color: isEnabled
                            ? AppColors.greyColor900
                            : AppColors.greyColor3003,
                      ),
                    ),
                    if (helperText != null) ...[
                      SizedBox(height: 3.h),
                      Text(
                        helperText!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.font10greyColor3003Weight400,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            _NotificationToggleWidget(
              value: value,
              isLoading: isLoading,
              isEnabled: isEnabled,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationToggleWidget extends StatelessWidget {
  final bool value;
  final bool isLoading;
  final bool isEnabled;

  const _NotificationToggleWidget({
    required this.value,
    required this.isLoading,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isLoading || !isEnabled ? .55 : 1,
      duration: const Duration(milliseconds: 120),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 32.w,
        height: 18.4.h,
        padding: EdgeInsetsDirectional.only(
          start: value ? 14.8.w : 0.8.w,
          end: value ? 0.8.w : 14.8.w,
          top: 0.8.h,
          bottom: 0.8.h,
        ),
        decoration: BoxDecoration(
          color: isEnabled && value
              ? AppColors.greenColor500
              : AppColors.greyColorE5,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Container(
          width: 16.r,
          height: 16.r,
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
