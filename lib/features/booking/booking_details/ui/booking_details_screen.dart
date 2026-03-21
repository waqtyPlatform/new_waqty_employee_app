import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/widgets/button_widget.dart';
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
                  Spacer(flex: 1),
                  Text(
                    'Booking Details',
                    style: TextStyles.font18greyColor900Weight600,
                  ),
                  Spacer(flex: 2),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      verticalSpace(16),
                      BookingUserInfoWidget(
                        bookingStatus: 'processing',
                        bookingId: 'BK-00473',
                        userName: 'Ahmed khattab',
                      ),
                      verticalSpace(12),
                      BookingAppointmentInfoWidget(
                        bookingDate: 'Thursday, March 5',
                        bookingTime: '1:00 PM – 2:30 PM · 90 minutes',
                        roomAddress: 'Room 1',
                      ),
                      verticalSpace(12),
                      BookingServicesWidget(),
                      verticalSpace(12),
                      BookingNotesWidget(notes: 'No special notes'),
                      verticalSpace(12),
                      BookingCustomerVisitsWidget(),
                      verticalSpace(12),
                      BookingAppointmentCompletedSuccesfullyWidget(
                        bookingStatus: 'completed',
                      ),
                      verticalSpace(12),

                      BookingReviewUserWidget(userName: 'Ahmed khattab'),
                      verticalSpace(12),
                      //buttons
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

                      verticalSpace(8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
