import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/assets_manager.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileUserLogOutWidget extends StatelessWidget {
  const ProfileUserLogOutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColorFA, width: 0.8.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withOpacity(0.04),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: AppColors.errorColor2003,
                child: SvgPicture.asset(ImageAsset.logOutIcon),
              ),
              horizontalSpace(8),
              Expanded(
                child: Text(
                  'Log Out',
                  maxLines: 1,
                  style: TextStyles.font14errorColor2002W500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
