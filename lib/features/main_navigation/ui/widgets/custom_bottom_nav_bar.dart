import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/features/main_navigation/ui/widgets/bottom_nav_bar_item_widget.dart';
import 'package:new_waqty_employee_app/features/main_navigation/ui/widgets/bottom_nav_item_model.dart';
import 'package:new_waqty_employee_app/core/utils/assets_manager.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import '../../../../core/utils/app_colors_white_theme.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<BottomNavItemModel> _items = [
    BottomNavItemModel(
      icon: ImageAsset.homeIcon,
      labelKey: 'mainNavigation.home',
    ),
    BottomNavItemModel(
      icon: ImageAsset.bookingIcon,
      labelKey: 'mainNavigation.booking',
    ),
    BottomNavItemModel(
      icon: ImageAsset.statsIcon,
      labelKey: 'mainNavigation.stats',
    ),
    BottomNavItemModel(
      icon: ImageAsset.moneyIcon,
      labelKey: 'mainNavigation.money',
    ),
    BottomNavItemModel(
      icon: ImageAsset.accountIcon,
      labelKey: 'mainNavigation.account',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor200.withValues(alpha: 0.3),
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
        items: _items
            .map((item) => BottomNavBarItemWidget.build(context, item))
            .toList(),
      ),
    );
  }
}
