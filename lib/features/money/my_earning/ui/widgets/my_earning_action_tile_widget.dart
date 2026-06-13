import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/my_earning_card_decoration.dart';

class MyEarningPayslipsTileWidget extends StatelessWidget {
  const MyEarningPayslipsTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MyEarningActionTileWidget(
      title: context.tr('myEarning.payslips'),
      subtitle: context.tr('myEarning.viewDownload'),
      icon: Icons.file_download_outlined,
    );
  }
}

class MyEarningBonusesTileWidget extends StatelessWidget {
  const MyEarningBonusesTileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MyEarningActionTileWidget(
      title: context.tr('myEarning.bonuses'),
      subtitle: context.tr('myEarning.bonusEarnedThisMonth'),
      icon: Icons.card_giftcard_outlined,
    );
  }
}

class MyEarningActionTileWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const MyEarningActionTileWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74.6.h,
      padding: EdgeInsets.symmetric(horizontal: 16.8.w),
      decoration: myEarningCardDecoration(),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: AppColors.greenColor500.withValues(alpha: .06),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.greenColor500, size: 20.r),
          ),
          horizontalSpace(8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyles.font14greyColor900Weight500),
                verticalSpace(2),
                Text(subtitle, style: TextStyles.font12greyColorA3W400),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.greyColor100, size: 24.r),
        ],
      ),
    );
  }
}
