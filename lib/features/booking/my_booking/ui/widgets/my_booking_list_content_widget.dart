import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/logic/my_booking_cubit.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/ui/widgets/my_booking_canceled_list_widget.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/ui/widgets/my_booking_completed_list_widget.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/ui/widgets/my_booking_upcoming_list_widget.dart';

class MyBookingListContentWidget extends StatelessWidget {
  final MyBookingCubit cubit;

  const MyBookingListContentWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        cubit.getMyBookings(refresh: true);
      },
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (cubit.isBookingsLoading) {
      return const SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 400,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (cubit.bookings.isEmpty) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: 400,
          child: Center(
            child: Text(
              context.tr('myBooking.noBookingsFound'),
              style: TextStyles.font14greyColor500W500,
            ),
          ),
        ),
      );
    }

    return _buildSelectedTabBookings();
  }

  Widget _buildSelectedTabBookings() {
    switch (cubit.selectedTabIndex) {
      case 1:
        return MyBookingCompletedListWidget(
          bookings: cubit.bookings,
          scrollController: cubit.bookingsScrollController,
          isPaginationLoading: cubit.isBookingsPaginationLoading,
          onLoadMore: cubit.onBookingsScrollEnd,
        );
      case 2:
        return MyBookingCanceledListWidget(
          bookings: cubit.bookings,
          scrollController: cubit.bookingsScrollController,
          isPaginationLoading: cubit.isBookingsPaginationLoading,
          onLoadMore: cubit.onBookingsScrollEnd,
        );
      case 0:
      default:
        return MyBookingUpcomingListWidget(
          bookings: cubit.bookings,
          scrollController: cubit.bookingsScrollController,
          isPaginationLoading: cubit.isBookingsPaginationLoading,
          onLoadMore: cubit.onBookingsScrollEnd,
        );
    }
  }
}
