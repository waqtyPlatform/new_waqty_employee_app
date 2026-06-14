import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class BonusTotalCardWidget extends StatelessWidget {
  const BonusTotalCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: myEarningCardDecoration(),
      child: Column(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: const BoxDecoration(
              color: AppColors.warningColor1002,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium_outlined,
              color: AppColors.warningColor1001,
              size: 24.r,
            ),
          ),
          verticalSpace(8),
          Text(
            context.tr('myEarning.totalBonusMarch'),
            style: TextStyles.font12greyColorA3W400,
          ),
          verticalSpace(6),
          Text('EGP 250', style: TextStyles.font32greyColor900Weight600),
        ],
      ),
    );
  }
}
