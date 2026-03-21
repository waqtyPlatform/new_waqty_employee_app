import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/main_navigation/cubit/main_navigation_cubit.dart';
import 'appointment_card_widget.dart';

class HomeUpcomingAppointmentsWidget extends StatelessWidget {
  const HomeUpcomingAppointmentsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "Upcoming Appointments ",
                style: TextStyles.font18greyColor900Weight600,
              ),
            ),

            GestureDetector(
              onTap: () {
                MainNavigationCubit.get(context).changeTab(1);
              },
              child: Text(
                'See All',
                style: TextStyles.font14greenColor500Weight600,
              ),
            ),
          ],
        ),
        verticalSpace(16),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, Routes.bookingDetailsScreen);
          },
          child: const AppointmentCardWidget(
            imageUrl:
                'https://images.unsplash.com/photo-1599839619722-39751411ea63?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
            clientName: 'Mohamed Ahmed',
            services: 'Undercut Haircut, Regular Shaving, Na...',
            date: 'Dec 22, 2024',
            time: '10:00 AM',
            room: 'Room 1',
          ),
        ),
        verticalSpace(16),
        const AppointmentCardWidget(
          imageUrl:
              'https://images.unsplash.com/photo-1622286342621-4bd786c2447c?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
          clientName: 'Sarah Johnson',
          services: 'Fade Haircut, Beard Trim, Scalp Massa...',
          date: 'Dec 22, 2024',
          time: '11:00 AM',
          room: 'Room 1',
        ),
      ],
    );
  }
}
