import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/notifications/data/models/notification_inbox_group_model.dart';
import 'package:new_waqty_employee_app/features/notifications/ui/widgets/notification_card_widget.dart';

class NotificationGroupWidget extends StatelessWidget {
  final NotificationInboxGroupModel group;
  final ValueChanged<NotificationInboxItemModel>? onItemTap;

  const NotificationGroupWidget({
    super.key,
    required this.group,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.title.toUpperCase(),
          style: TextStyles.font10greyColor3003Weight500,
        ),
        verticalSpace(10),
        ...group.items.map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: NotificationCardWidget(
              item: item,
              onTap: onItemTap == null ? null : () => onItemTap!(item),
            ),
          ),
        ),
      ],
    );
  }
}
