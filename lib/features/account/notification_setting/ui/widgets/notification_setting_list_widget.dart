import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';

class NotificationSettingListWidget extends StatelessWidget {
  const NotificationSettingListWidget({super.key});

  static const List<String> _notificationKeys = [
    'notifications.newBookings',
    'notifications.bookingCancellations',
    'notifications.appointmentReminders',
    'notifications.shiftStartReminders',
    'notifications.newReviews',
    'notifications.payslipAvailable',
    'notifications.managerAnnouncements',
  ];

  @override
  Widget build(BuildContext context) {
    return AccountSupportCardWidget(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: List.generate(_notificationKeys.length, (index) {
          return NotificationSettingItemWidget(
            title: context.tr(_notificationKeys[index]),
            showDivider: index != _notificationKeys.length - 1,
          );
        }),
      ),
    );
  }
}

class NotificationSettingItemWidget extends StatelessWidget {
  final String title;
  final bool showDivider;

  const NotificationSettingItemWidget({
    super.key,
    required this.title,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const _NotificationToggleWidget(),
        ],
      ),
    );
  }
}

class _NotificationToggleWidget extends StatelessWidget {
  const _NotificationToggleWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.w,
      height: 18.4.h,
      padding: EdgeInsetsDirectional.only(
        start: 14.8.w,
        end: 0.8.w,
        top: 0.8.h,
        bottom: 0.8.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.greenColor500,
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
    );
  }
}
