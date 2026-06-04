import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/logic/my_booking_cubit.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/logic/my_booking_state.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/ui/widgets/my_booking_days_list_widget.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/ui/widgets/my_booking_list_content_widget.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/ui/widgets/my_booking_tab_bar_widget.dart';

class MyBookingBodyWidget extends StatelessWidget {
  const MyBookingBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyBookingCubit, MyBookingState>(
      buildWhen: (previous, current) {
        return current is InitialState ||
            current is OnMyBookingLoadingState ||
            current is OnMyBookingSuccessState ||
            current is OnMyBookingPaginationLoadingState ||
            current is OnMyBookingPaginationSuccessState ||
            current is OnMyBookingErrorState ||
            current is OnMyBookingCatchErrorState ||
            current is OnMyBookingViewModeChangedState;
      },
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
            Expanded(child: MyBookingListContentWidget(cubit: cubit)),
          ],
        );
      },
    );
  }
}
