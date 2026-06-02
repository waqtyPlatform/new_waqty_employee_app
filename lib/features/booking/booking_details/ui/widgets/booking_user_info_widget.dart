import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingUserInfoWidget extends StatelessWidget {
  final String userName;
  final String bookingId;
  final String bookingStatus;
  const BookingUserInfoWidget({
    Key? key,
    required this.userName,
    required this.bookingId,
    required this.bookingStatus,
  }) : super(key: key);

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
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.greenColor500.withValues(alpha: .12),
            child: Text(
              (userName.length >= 2 ? userName.substring(0, 2) : userName)
                  .toUpperCase(),
              style: TextStyles.font14greenColor500Weight600,
            ),
          ),
          horizontalSpace(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  maxLines: 1,
                  style: TextStyles.font16greyColor900Weight600,
                ),
                verticalSpace(2),
                Text(
                  bookingId,
                  maxLines: 1,
                  style: TextStyles.font12greyColorA3W400,
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16.r)),
              color: _getStatusBgColor(),
            ),
            child: Text(
              _getStatusLabel(),
              style: TextStyles.font12warningColor1001Weight500.copyWith(
                color: _getStatusTextColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusBgColor() {
    switch (bookingStatus.toLowerCase()) {
      case 'processing':
        return AppColors.warningColor1002;
      case 'upcoming':
        return AppColors.blueColor5055;
      case 'confirmed':
        return AppColors.blueColor5055;
      case 'completed':
        return AppColors.greenColor5005;
      case 'canceled':
      case 'cancelled':
        return AppColors.errorColor2003;
      default:
        return AppColors.greyColor0;
    }
  }

  Color _getStatusTextColor() {
    switch (bookingStatus.toLowerCase()) {
      case 'processing':
        return AppColors.warningColor1001;
      case 'upcoming':
        return AppColors.blueColor506;
      case 'confirmed':
        return AppColors.blueColor506;
      case 'completed':
        return AppColors.greenColor500;
      case 'canceled':
      case 'cancelled':
        return AppColors.errorColor2002;
      default:
        return AppColors.warningColor1002;
    }
  }

  String _getStatusLabel() {
    switch (bookingStatus.toLowerCase()) {
      case 'processing':
        return 'Processing';
      case 'upcoming':
        return 'Upcoming';
      case 'confirmed':
        return 'Confirmed';
      case 'completed':
        return 'Completed';
      case 'canceled':
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'processing';
    }
  }
}
