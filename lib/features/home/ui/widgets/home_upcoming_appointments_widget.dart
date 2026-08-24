import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/home/data/models/home_summary_model.dart';
import 'package:new_waqty_employee_app/features/main_navigation/cubit/main_navigation_cubit.dart';
import 'appointment_card_widget.dart';

class HomeUpcomingAppointmentsWidget extends StatelessWidget {
  final List<HomeAppointmentModel> appointments;

  const HomeUpcomingAppointmentsWidget({Key? key, required this.appointments})
    : super(key: key);

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
                context.tr('home.upcomingAppointments'),
                style: TextStyles.font18greyColor900Weight600,
              ),
            ),

            GestureDetector(
              onTap: () {
                MainNavigationCubit.get(context).changeTab(1);
              },
              child: Text(
                context.tr('home.seeAll'),
                style: TextStyles.font14greenColor500Weight600,
              ),
            ),
          ],
        ),
        verticalSpace(16),
        if (appointments.isEmpty)
          Text(
            context.tr('home.noAppointmentsLeftToday'),
            style: TextStyles.font14greyColor500W400,
          )
        else
          ...appointments.map(
            (appointment) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.bookingDetailsScreen,
                    arguments: {'uuid': appointment.bookingUuid},
                  );
                },
                child: AppointmentCardWidget(
                  imageUrl: appointment.customerAvatarUrl,
                  clientName: appointment.customerName,
                  services: appointment.servicesLabel,
                  date: appointment.dateLabel,
                  time: appointment.timeLabel,
                  room: appointment.slotLabel,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
