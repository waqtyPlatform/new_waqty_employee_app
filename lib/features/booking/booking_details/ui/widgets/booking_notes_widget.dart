import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/assets_manager.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BookingNotesWidget extends StatelessWidget {
  final String notes;
  const BookingNotesWidget({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(
          color: AppColors.greyColor1001.withValues(alpha: .2),
          width: .8,
        ),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: 0.03),
            blurRadius: 16,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: 0.04),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: AppColors.greyColorF5,
                child: SvgPicture.asset(ImageAsset.notesIcon),
              ),
              horizontalSpace(8),
              Text(
                context.tr('bookingDetails.notes'),
                style: TextStyles.font14greyColor900Weight500,
              ),
            ],
          ),
          verticalSpace(8),
          Text(notes, style: TextStyles.font14greyColorA3W400),
        ],
      ),
    );
  }
}
