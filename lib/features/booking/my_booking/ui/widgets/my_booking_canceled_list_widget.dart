import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/data/models/my_booking_response_model.dart';

import 'my_booking_item_card_widget.dart';

class MyBookingCanceledListWidget extends StatelessWidget {
  final List<MyBookingModel> bookings;
  final ScrollController scrollController;
  final bool isPaginationLoading;
  final VoidCallback onLoadMore;

  const MyBookingCanceledListWidget({
    super.key,
    required this.bookings,
    required this.scrollController,
    required this.isPaginationLoading,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 80.h) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.separated(
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        itemCount: bookings.length + (isPaginationLoading ? 1 : 0),
        separatorBuilder: (_, __) => verticalSpace(12),
        itemBuilder: (context, index) {
          if (index == bookings.length) {
            return const Center(child: CircularProgressIndicator());
          }
          final booking = bookings[index];
          return MyBookingItemCardWidget(
            bookingNumber: booking.uuid,
            bookingStatus: booking.status,
            bookingUuid: booking.uuid,
            bookingTime: booking.formattedStartTime,
            clientName: booking.customerName.isEmpty
                ? context.tr('myBooking.walkInCustomer')
                : booking.customerName,
            serviceName: booking.serviceNameForLanguage(
              context.locale.languageCode,
            ),
          );
        },
      ),
    );
  }
}
