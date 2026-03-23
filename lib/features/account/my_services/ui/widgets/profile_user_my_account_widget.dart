import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileMenuItemData {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  ProfileMenuItemData({
    required this.title,
    required this.iconPath,
    required this.onTap,
  });
}

class ProfileUserMyAccountWidget extends StatelessWidget {
  final List<ProfileMenuItemData> items;

  const ProfileUserMyAccountWidget({Key? key, required this.items})
    : super(key: key);

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
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: item.onTap,

            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16.r,
                    backgroundColor: AppColors.greyColorFA,
                    child: SvgPicture.asset(item.iconPath),
                  ),
                  horizontalSpace(8),
                  Expanded(
                    child: Text(
                      item.title,
                      maxLines: 1,
                      style: TextStyles.font14greyColor900Weight500,
                    ),
                  ),
                  horizontalSpace(8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14.r,
                    color: AppColors.greyColorE5,
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) =>
            Divider(color: AppColors.greyColor1001.withValues(alpha: .2)),
        itemCount: items.length,
      ),
    );
  }
}
