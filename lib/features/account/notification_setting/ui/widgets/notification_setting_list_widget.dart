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
      apiKey: NotificationSettingKey.shiftStartReminders,
      titleKey: 'notifications.shiftStartReminders',
    ),
    _NotificationSettingItem(
      apiKey: NotificationSettingKey.newReviews,
      titleKey: 'notifications.newReviews',
    ),
    _NotificationSettingItem(
      apiKey: NotificationSettingKey.payslipAvailable,
      titleKey: 'notifications.payslipAvailable',
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
            value: value,
            isLoading: updatingKey == item.apiKey,
            showDivider: index != _notificationItems.length - 1,
            onTap: updatingKey == null
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

  const _NotificationSettingItem({
    required this.apiKey,
    required this.titleKey,
  });
}

class NotificationSettingItemWidget extends StatelessWidget {
  final String title;
  final bool value;
  final bool isLoading;
  final bool showDivider;
  final VoidCallback? onTap;

  const NotificationSettingItemWidget({
    super.key,
    required this.title,
    required this.value,
    required this.isLoading,
    required this.showDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 46.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(bottom: BorderSide(color: AppColors.greyColorF5))
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.font14greyColor900Weight500,
              ),
            ),
            _NotificationToggleWidget(value: value, isLoading: isLoading),
          ],
        ),
      ),
    );
  }
}

class _NotificationToggleWidget extends StatelessWidget {
  final bool value;
  final bool isLoading;

  const _NotificationToggleWidget({
    required this.value,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isLoading ? .55 : 1,
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
          color: value ? AppColors.greenColor500 : AppColors.greyColorE5,
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
