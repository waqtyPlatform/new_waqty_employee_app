import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/button_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_cubit.dart';

class BookingActionButtonsWidget extends StatelessWidget {
  final BookingDetailsCubit cubit;

  const BookingActionButtonsWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ButtonWidget(
          isLoading: false,
          borderRadius: 12,
          buttonHeight: 52.h,
          buttonText: context.tr('bookingDetails.markAsStarted'),
          backGroundColor: AppColors.greenColor500,
          borderColor: AppColors.greenColor500,
          fourGroundColor: AppColors.whiteColor,
          textStyle: TextStyles.font16whiteColorWeight600,
          onPressed: () {},
        ),
        verticalSpace(8),
        ButtonWidget(
          isLoading: cubit.isUpdatingStatus,
          borderRadius: 12,
          buttonHeight: 52.h,
          borderWidth: 1.w,
          buttonText: context.tr('bookingDetails.markAsNoShow'),
          backGroundColor: AppColors.whiteColor,
          borderColor: AppColors.greyColorE5,
          fourGroundColor: AppColors.errorColor100,
          textStyle: TextStyles.font16errorColor100W600,
          onPressed: cubit.markBookingAsNoShow,
        ),
        verticalSpace(8),
        ButtonWidget(
          isLoading: false,
          borderRadius: 12,
          buttonHeight: 52.h,
          buttonText: context.tr('bookingDetails.markAsCompleted'),
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
