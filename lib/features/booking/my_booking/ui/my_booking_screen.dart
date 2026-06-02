import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/logic/my_booking_cubit.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/logic/my_booking_state.dart';

import 'widgets/my_booking_days_list_widget.dart';
import 'widgets/my_booking_tab_bar_widget.dart';
import 'widgets/my_booking_upcoming_list_widget.dart';
import 'widgets/my_booking_completed_list_widget.dart';
import 'widgets/my_booking_canceled_list_widget.dart';

class MyBookingScreen extends StatelessWidget {
  const MyBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Text(
          context.tr('myBooking.title'),
          style: TextStyles.font20greyColor900W600,
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<MyBookingCubit, MyBookingState>(
          builder: (context, state) {
            final cubit = MyBookingCubit.get(context);
            return Column(
              children: [
                verticalSpace(16),
                MyBookingDaysListWidget(
                  selectedDayIndex: cubit.selectedDayIndex,
                  onDaySelected: cubit.changeSelectedDay,
                ),

                verticalSpace(16),

                MyBookingTabBarWidget(
                  selectedTabIndex: cubit.selectedTabIndex,
                  onTabSelected: cubit.changeSelectedTab,
                ),

                Expanded(
                  child: cubit.isBookingsLoading
                      ? const Center(child: CircularProgressIndicator())
                      : cubit.bookings.isEmpty
                      ? Center(
                          child: Text(
                            context.tr('myBooking.noBookingsFound'),
                            style: TextStyles.font14greyColor500W500,
                          ),
                        )
                      : _buildTabBody(cubit),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabBody(MyBookingCubit cubit) {
    switch (cubit.selectedTabIndex) {
      case 0:
        return MyBookingUpcomingListWidget(
          bookings: cubit.bookings,
          scrollController: cubit.bookingsScrollController,
          isPaginationLoading: cubit.isBookingsPaginationLoading,
          onLoadMore: cubit.onBookingsScrollEnd,
        );
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
