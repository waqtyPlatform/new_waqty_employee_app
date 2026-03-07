import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/assets_manager.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import '../../../../core/utils/app_colors_white_theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor200.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        selectedItemColor: AppColors.greenColor500,
        unselectedItemColor: AppColors.greyColor300,

        selectedLabelStyle: TextStyles.font12greenColor500W600,
        unselectedLabelStyle: TextStyles.font12greyColor3003Weight400,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(ImageAsset.homeIcon),
            activeIcon: SvgPicture.asset(ImageAsset.homeSelectedIcon),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(ImageAsset.bookingIcon),
            activeIcon: SvgPicture.asset(ImageAsset.bookingSelectedIcon),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(ImageAsset.performanceIcon),
            activeIcon: SvgPicture.asset(
              ImageAsset.performanceSelectedIcon,
              color: AppColors.greenColor500,
            ),
            label: 'Performance',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(ImageAsset.moneyIcon),
            activeIcon: SvgPicture.asset(
              ImageAsset.moneyIcon,
              color: AppColors.greenColor500,
            ),
            label: 'Money',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(ImageAsset.accountIcon),
            activeIcon: SvgPicture.asset(
              ImageAsset.accountIcon,
              color: AppColors.greenColor500,
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
