import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/cached_network_image.dart';

class AppointmentCardWidget extends StatelessWidget {
  /// Empty when there is no photo to show — the booking API carries no customer
  /// image, so the card falls back to the initial instead of a broken box.
  final String imageUrl;
  final String clientName;
  final String services;
  final String date;
  final String time;
  final String room;

  const AppointmentCardWidget({
    Key? key,
    this.imageUrl = '',
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
            child: imageUrl.isEmpty
                ? _InitialAvatar(name: clientName)
                : CachedNetworkImageWidget(
                    imgUrl: imageUrl,
                    radius: BorderRadius.circular(8.r),
                  ),
          ),
          horizontalSpace(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  clientName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font16greyColor900Weight600,
                ),

                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${context.tr('home.services')}:\n ',
                        style: TextStyles.font12greyColor500W500,
                      ),
                      TextSpan(
                        text: services.trim().isEmpty ? '--' : services,
                        style: TextStyles.font12greyColor500W400,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  [
                    date,
                    time,
                    room,
                  ].where((item) => item.trim().isNotEmpty).join(' • '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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

class _InitialAvatar extends StatelessWidget {
  final String name;

  const _InitialAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final initial = trimmed.isEmpty
        ? '?'
        : String.fromCharCode(trimmed.runes.first);

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.greenColor505,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(initial, style: TextStyles.font18greyColor900Weight600),
    );
  }
}
