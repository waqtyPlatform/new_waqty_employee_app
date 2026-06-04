import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_details_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_cubit.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_state.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_action_buttons_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_add_service_bottom_sheet.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_appointment_completed_succesfully_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_appointment_info_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_customer_visits_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_notes_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_review_user_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_services_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_user_info_widget.dart';

class BookingDetailsBodyWidget extends StatelessWidget {
  const BookingDetailsBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingDetailsCubit, BookingDetailsState>(
      buildWhen: (previous, current) {
        return current is OnBookingDetailsLoadingState ||
            current is OnBookingDetailsSuccessState ||
            current is OnBookingDetailsStatusLoadingState ||
            current is OnBookingDetailsStatusSuccessState ||
            current is OnBookingDetailsErrorState ||
            current is OnBookingDetailsCatchErrorState;
      },
      builder: (context, state) {
        final cubit = BookingDetailsCubit.get(context);
        final booking = cubit.bookingDetails;

        if (state is OnBookingDetailsLoadingState && booking == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (booking == null) {
          return RefreshIndicator(
            onRefresh: cubit.refreshBookingDetails,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 400.h,
                child: Center(
                  child: Text(
                    context.tr('bookingDetails.notFound'),
                    style: TextStyles.font14greyColor500W500,
                  ),
                ),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: cubit.refreshBookingDetails,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: _BookingDetailsContent(booking: booking, cubit: cubit),
          ),
        );
      },
    );
  }
}

class _BookingDetailsContent extends StatelessWidget {
  final BookingDetailsModel booking;
  final BookingDetailsCubit cubit;

  const _BookingDetailsContent({required this.booking, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final customerName = booking.customerName.isEmpty
        ? context.tr('myBooking.walkInCustomer')
        : booking.customerName;

    return Column(
      children: [
        verticalSpace(8),
        BookingUserInfoWidget(
          bookingStatus: booking.status,
          bookingId: booking.bookingNumber,
          userName: customerName,
        ),
        verticalSpace(12),
        BookingAppointmentInfoWidget(
          bookingDate: _formatBookingDate(booking.bookingDate, context),
          bookingTime:
              '${booking.formattedStartTime} - ${booking.formattedEndTime} · ${booking.durationMinutes} ${context.tr('bookingDetails.minutes')}',
          roomAddress: booking.branch.name,
        ),
        verticalSpace(12),
        BookingServicesWidget(
          serviceName: booking.serviceNameForLanguage(
            context.locale.languageCode,
          ),
          duration:
              '${booking.durationMinutes} ${context.tr('bookingDetails.min')}',
          price: booking.price,
          currency: booking.currency,
          onAddTap: () =>
              showAddServiceBottomSheet(context, cubit, booking.currency),
        ),
        verticalSpace(12),
        BookingNotesWidget(
          notes: booking.notes?.isEmpty ?? true
              ? context.tr('bookingDetails.noSpecialNotes')
              : booking.notes!,
        ),
        verticalSpace(12),
        BookingCustomerVisitsWidget(
          phone: booking.user?.phone ?? '',
          notes: booking.notes ?? '',
        ),
        if (booking.status.toLowerCase() == 'completed') ...[
          verticalSpace(12),
          BookingAppointmentCompletedSuccesfullyWidget(
            bookingStatus: booking.status,
          ),
        ],
        verticalSpace(12),
        BookingReviewUserWidget(userName: customerName),
        verticalSpace(12),
        BookingActionButtonsWidget(cubit: cubit),
        verticalSpace(8),
      ],
    );
  }

  String _formatBookingDate(String value, BuildContext context) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;

    final weekdays = context.locale.languageCode == 'ar'
        ? [
            'الاثنين',
            'الثلاثاء',
            'الأربعاء',
            'الخميس',
            'الجمعة',
            'السبت',
            'الأحد',
          ]
        : [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday',
          ];
    final months = context.locale.languageCode == 'ar'
        ? [
            'يناير',
            'فبراير',
            'مارس',
            'أبريل',
            'مايو',
            'يونيو',
            'يوليو',
            'أغسطس',
            'سبتمبر',
            'أكتوبر',
            'نوفمبر',
            'ديسمبر',
          ]
        : [
            'January',
            'February',
            'March',
            'April',
            'May',
            'June',
            'July',
            'August',
            'September',
            'October',
            'November',
            'December',
          ];

    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}
