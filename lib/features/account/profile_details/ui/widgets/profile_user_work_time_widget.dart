import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class ProfileUserWorkTimeWidget extends StatelessWidget {
  final String type;
  final String time;

  const ProfileUserWorkTimeWidget({
    Key? key,
    required this.type,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.errorColor2003,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.errorColor20033, width: 0.8.w),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.errorColor20033,
            child: Icon(
              Icons.timer_outlined,
              color: AppColors.errorColor2002,
              size: 20.r,
            ),
          ),
          horizontalSpace(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: TextStyles.font14greyColor900Weight600),
                verticalSpace(2),
                Text(
                  time,
                  style: TextStyles.font12greyColorA3W400,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.errorColor200333,
            size: 16.r,
          ),
        ],
      ),
    );
  }
}
