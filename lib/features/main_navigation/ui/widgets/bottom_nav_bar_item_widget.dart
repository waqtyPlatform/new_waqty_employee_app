import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/features/main_navigation/ui/widgets/bottom_nav_item_model.dart';

class BottomNavBarItemWidget {
  static BottomNavigationBarItem build(
    BuildContext context,
    BottomNavItemModel item,
  ) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(item.icon),
      activeIcon: SvgPicture.asset(
        item.icon,
        colorFilter: const ColorFilter.mode(
          AppColors.greenColor500,
          BlendMode.srcIn,
        ),
      ),
      label: context.tr(item.labelKey),
    );
  }
}
