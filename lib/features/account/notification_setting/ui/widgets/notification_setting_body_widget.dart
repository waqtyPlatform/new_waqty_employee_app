import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/ui/widgets/notification_setting_list_widget.dart';

class NotificationSettingBodyWidget extends StatelessWidget {
  const NotificationSettingBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: const NotificationSettingListWidget(),
    );
  }
}
