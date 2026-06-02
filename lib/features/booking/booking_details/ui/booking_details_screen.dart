import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/button_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_cubit.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_state.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_appointment_completed_succesfully_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_appointment_info_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_customer_visits_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_notes_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_review_user_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_services_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_user_info_widget.dart';

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
              Row(
                children: [
                  Container(
                    height: 48.r,
                    width: 48.r,
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.whiteColor,
                      border: Border.all(color: AppColors.greyColor50),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.greyColor900,
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                  Text(
                    'Booking Details',
                    style: TextStyles.font18greyColor900Weight600,
                  ),
                  const Spacer(flex: 2),
                ],
              ),
              Expanded(
                child: BlocBuilder<BookingDetailsCubit, BookingDetailsState>(
                  builder: (context, state) {
                    final cubit = BookingDetailsCubit.get(context);
                    final booking = cubit.bookingDetails;

                    if (state is OnBookingDetailsLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (booking == null) {
                      return Center(
                        child: Text(
                          'Booking details not found',
                          style: TextStyles.font14greyColor500W500,
                        ),
                      );
                    }

                    final customerName = booking.customerName.isEmpty
                        ? context.tr('myBooking.walkInCustomer')
                        : booking.customerName;

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          verticalSpace(16),
                          BookingUserInfoWidget(
                            bookingStatus: booking.status,
                            bookingId: booking.bookingNumber,
                            userName: customerName,
                          ),
                          verticalSpace(12),
                          BookingAppointmentInfoWidget(
                            bookingDate: _formatBookingDate(
                              booking.bookingDate,
                              context.locale.languageCode,
                            ),
                            bookingTime:
                                '${booking.formattedStartTime} - ${booking.formattedEndTime} · ${booking.durationMinutes} minutes',
                            roomAddress: booking.branch.name,
                          ),
                          verticalSpace(12),
                          BookingServicesWidget(
                            serviceName: booking.serviceNameForLanguage(
                              context.locale.languageCode,
                            ),
                            duration: '${booking.durationMinutes} min',
                            price: booking.price,
                            currency: booking.currency,
                          ),
                          verticalSpace(12),
                          BookingNotesWidget(
                            notes: booking.notes?.isEmpty ?? true
                                ? 'No special notes'
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
                          const _BookingActionButtons(),
                          verticalSpace(8),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatBookingDate(String value, String languageCode) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;

    final weekdays = languageCode == 'ar'
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
    final months = languageCode == 'ar'
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

class _BookingActionButtons extends StatelessWidget {
  const _BookingActionButtons();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonWidget(
          isLoading: false,
          borderRadius: 12,
          buttonHeight: 52.h,
          buttonText: 'Mark as Started',
          backGroundColor: AppColors.greenColor500,
          borderColor: AppColors.greenColor500,
          fourGroundColor: AppColors.whiteColor,
          textStyle: TextStyles.font16whiteColorWeight600,
          onPressed: () {},
        ),
        verticalSpace(8),
        ButtonWidget(
          isLoading: false,
          borderRadius: 12,
          buttonHeight: 52.h,
          borderWidth: 1.w,
          buttonText: 'Mark as No-Show',
          backGroundColor: AppColors.whiteColor,
          borderColor: AppColors.greyColorE5,
          fourGroundColor: AppColors.errorColor100,
          textStyle: TextStyles.font16errorColor100W600,
          onPressed: () {},
        ),
        verticalSpace(8),
        ButtonWidget(
          isLoading: false,
          borderRadius: 12,
          buttonHeight: 52.h,
          buttonText: 'Mark as Completed',
          backGroundColor: AppColors.greenColor500,
          borderColor: AppColors.greenColor500,
          fourGroundColor: AppColors.whiteColor,
          textStyle: TextStyles.font16whiteColorWeight600,
          onPressed: () {},
        ),
      ],
    );
  }
}
