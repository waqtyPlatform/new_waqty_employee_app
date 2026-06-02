import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/cached_network_image.dart';

class MyBookingItemCardWidget extends StatelessWidget {
  final String bookingTime;
  final String bookingNumber;
  final String bookingStatus;

  final String clientName;
  final String serviceName;

  const MyBookingItemCardWidget({
    super.key,
    required this.bookingTime,
    required this.bookingNumber,
    required this.bookingStatus,
    required this.clientName,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.bookingDetailsScreen);
      },
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.greyColor50),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 24.r,
                  color: AppColors.greenColor500,
                ),
                horizontalSpace(4),
                Text(bookingTime, style: TextStyles.font12greyColorA3W400),
                Spacer(),

                //booking status
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
                horizontalSpace(8),
                //booking number
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.r)),
                    border: Border.all(color: AppColors.greyColorF5),
                    color: AppColors.whiteColor,
                  ),
                  child: Text(
                    bookingNumber,
                    style: TextStyles.font14greenColor500Weight600,
                  ),
                ),
              ],
            ),
            verticalSpace(14),
            Divider(color: AppColors.greyColor50, thickness: 1),
            verticalSpace(16),

            //booking info
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80.w,
                  height: 80.h,
                  child: CachedNetworkImageWidget(
                    imgUrl:
                    'https://images.unsplash.com/photo-1599839619722-39751411ea63?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
                    radius: BorderRadius.circular(8.r),
                  ),
                ),
                horizontalSpace(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clientName,
                        style: TextStyles.font16greyColor900Weight600,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Services:\n ',
                              style: TextStyles.font12greyColor500W600,
                            ),
                            TextSpan(
                              text: serviceName,
                              style: TextStyles.font12greyColor500W400,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            verticalSpace(16),






          ],
        ),
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
        return 'Canceled';
      default:
        return 'processing';
    }
  }



}
