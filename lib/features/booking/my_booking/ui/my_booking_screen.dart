import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/ui/widgets/my_booking_app_bar_widget.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/ui/widgets/my_booking_body_widget.dart';

class MyBookingScreen extends StatelessWidget {
  const MyBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: MyBookingAppBarWidget(),
      body: SafeArea(child: MyBookingBodyWidget()),
    );
  }
}
