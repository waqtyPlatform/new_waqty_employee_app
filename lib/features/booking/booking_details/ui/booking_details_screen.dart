import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_details_body_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_details_header_widget.dart';

class BookingDetailsScreen extends StatelessWidget {
  const BookingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              const BookingDetailsHeaderWidget(),
              verticalSpace(8),
              const Expanded(child: BookingDetailsBodyWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
