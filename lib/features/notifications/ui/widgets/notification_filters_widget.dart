import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class NotificationFiltersWidget extends StatelessWidget {
  final String selectedStatus;
  final int unreadCount;
  final VoidCallback onAllTap;
  final VoidCallback onUnreadTap;
  final VoidCallback onMarkAllRead;

  const NotificationFiltersWidget({
    super.key,
    required this.selectedStatus,
    required this.unreadCount,
    required this.onAllTap,
    required this.onUnreadTap,
    required this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          _FilterPill(
            label: context.tr('notificationInbox.all'),
            isSelected: selectedStatus == 'all',
            onTap: onAllTap,
          ),
          horizontalSpace(8),
          _FilterPill(
            label: '${context.tr('notificationInbox.unread')} ($unreadCount)',
            isSelected: selectedStatus == 'unread',
            onTap: onUnreadTap,
          ),
          const Spacer(),
          InkWell(
            onTap: onMarkAllRead,
            borderRadius: BorderRadius.circular(8.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 6.h),
              child: Text(
                context.tr('notificationInbox.markAllRead'),
                style: TextStyles.font12greenColor500W600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterPill({
    required this.label,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.greenColor500
              : AppColors.greyColor25.withValues(alpha: .45),
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: isSelected ? AppColors.greenColor500 : AppColors.greyColor25,
            width: 1.w,
          ),
        ),
        child: Text(
          label,
          style: TextStyles.font12greyColor900Weight500.copyWith(
            color: isSelected ? AppColors.whiteColor : AppColors.greyColor500,
          ),
        ),
      ),
    );
  }
}
