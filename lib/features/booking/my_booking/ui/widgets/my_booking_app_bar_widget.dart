import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class MyBookingAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const MyBookingAppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      title: Text(
        context.tr('myBooking.title'),
        style: TextStyles.font20greyColor900W600,
      ),
    );
  }
}
