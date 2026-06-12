import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/assets_manager.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_user_my_account_widget.dart';
import 'package:new_waqty_employee_app/features/auth/login/ui/widgets/change_language_icon_widget.dart';

class ProfileUserSettingWidget extends StatelessWidget {
  const ProfileUserSettingWidget({super.key});

  List<ProfileMenuItemData> get items => [
    ProfileMenuItemData(
      title: 'profile.language',
      iconPath: ImageAsset.languageIcon,
      onTap: () {},
    ),
    ProfileMenuItemData(
      title: 'profile.notifications',
      iconPath: ImageAsset.profileNotificationIcon,
      onTap: () {},
    ),
    ProfileMenuItemData(
      title: 'profile.darkMode',
      iconPath: ImageAsset.darkModeIcon,
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColorFA, width: 0.8.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: 0.04),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: index == 1
                ? () => Navigator.pushNamed(
                    context,
                    Routes.notificationSettingScreen,
                  )
                : item.onTap,

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
                      context.tr(item.title),
                      maxLines: 1,
                      style: TextStyles.font14greyColor900Weight500,
                    ),
                  ),
                  horizontalSpace(8),

                  if (index == 0) const ChangeLanguageIconWidget(),
                  if (index == 1)
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14.r,
                      color: AppColors.greyColorE5,
                    ),
                  if (index == 2) const _ProfileDarkModeToggleWidget(),
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

class _ProfileDarkModeToggleWidget extends StatelessWidget {
  const _ProfileDarkModeToggleWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58.67.w,
      height: 32.h,
      padding: EdgeInsets.all(2.67.r),
      decoration: BoxDecoration(
        color: AppColors.greyColor50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        width: 26.67.r,
        height: 26.67.r,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.greyColor900.withValues(alpha: .1),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}
