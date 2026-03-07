import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/cached_network_image.dart';

class AppointmentCardWidget extends StatelessWidget {
  final String imageUrl;
  final String clientName;
  final String services;
  final String date;
  final String time;
  final String room;

  const AppointmentCardWidget({
    Key? key,
    required this.imageUrl,
    required this.clientName,
    required this.services,
    required this.date,
    required this.time,
    required this.room,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColor1001.withOpacity(.2)),

        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withOpacity(0.03),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.greyColor900.withOpacity(0.04),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80.w,
            height: 80.h,
            child: CachedNetworkImageWidget(
              imgUrl: imageUrl,
              radius: BorderRadius.circular(8.r),
            ),
          ),
          horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(clientName, style: TextStyles.font16greyColor900Weight600),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Services:\n ',
                        style: TextStyles.font12greyColor500W500,
                      ),
                      TextSpan(
                        text: services,
                        style: TextStyles.font12greyColor500W400,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '$date • $time • $room',
                  style: TextStyles.font12greyColor900Weight400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
