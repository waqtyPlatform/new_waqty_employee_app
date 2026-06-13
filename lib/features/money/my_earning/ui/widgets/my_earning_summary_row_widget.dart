import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/my_earning_card_decoration.dart';

class MyEarningSummaryRowWidget extends StatelessWidget {
  const MyEarningSummaryRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MoneySummaryCardWidget(
            icon: Icons.account_balance_outlined,
            label: context.tr('myEarning.salary'),
            amount: 'EGP 3,000',
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _MoneySummaryCardWidget(
            icon: Icons.trending_up,
            label: context.tr('myEarning.commission'),
            amount: 'EGP 2,100',
            iconColor: AppColors.warningColor1001,
            iconBackground: AppColors.warningColor1002,
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _MoneySummaryCardWidget(
            icon: Icons.card_giftcard_outlined,
            label: context.tr('myEarning.bonus'),
            amount: '+ EGP 250',
          ),
        ),
      ],
    );
  }
}

class _MoneySummaryCardWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final Color iconColor;
  final Color iconBackground;

  const _MoneySummaryCardWidget({
    required this.icon,
    required this.label,
    required this.amount,
    this.iconColor = AppColors.greenColor500,
    this.iconBackground = const Color(0x0F009354),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: .8.w, vertical: 8.8.h),
      decoration: myEarningCardDecoration(),
      child: Column(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16.r),
          ),
          verticalSpace(8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font10greyColorA3W600,
          ),
          verticalSpace(4),
          Text(
            amount,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font14greyColor900Weight600,
          ),
        ],
      ),
    );
  }
}
