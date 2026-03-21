import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        centerTitle: false,
        title: Text('My Booking', style: TextStyles.font20greyColor900W600),
      ),
      body: BlocBuilder<MyBookingCubit, MyBookingState>(
        ///build when state is InitialState
        // buildWhen: (previous, current) => current is InitialState,
        builder: (context, state) {
          final cubit = MyBookingCubit.get(context);
          return Column(
            children: [
              verticalSpace(16),
              // Days Horizontal List
              MyBookingDaysListWidget(
                selectedDayIndex: cubit.selectedDayIndex,
                onDaySelected: (index) => cubit.changeSelectedDay(index),
              ),

              verticalSpace(16),

              // Tab Bar (Upcoming / Completed / Canceled)
              MyBookingTabBarWidget(
                selectedTabIndex: cubit.selectedTabIndex,
                onTabSelected: (index) => cubit.changeSelectedTab(index),
              ),

              // Tab Body
              Expanded(child: _buildTabBody(cubit.selectedTabIndex)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabBody(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return const MyBookingUpcomingListWidget();
      case 1:
        return const MyBookingCompletedListWidget();
      case 2:
        return const MyBookingCanceledListWidget();
      default:
        return const MyBookingUpcomingListWidget();
    }
  }
}
