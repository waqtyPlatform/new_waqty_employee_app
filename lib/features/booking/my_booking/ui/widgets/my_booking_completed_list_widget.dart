import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';

import 'my_booking_item_card_widget.dart';

class MyBookingCompletedListWidget extends StatelessWidget {
  const MyBookingCompletedListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real data from cubit
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      itemCount: 3,
      separatorBuilder: (_, __) => verticalSpace(12),
      itemBuilder: (context, index) {
        return MyBookingItemCardWidget(
          bookingNumber: '1',
          bookingStatus: 'completed',
          bookingTime: '10:00 AM',
          clientName: 'Client ${index + 1}',
          serviceName: 'Beard Trim',
        );
      },
    );
  }
}
