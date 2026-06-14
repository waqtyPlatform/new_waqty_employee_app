import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/data/models/daily_earning_details_args.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class DailyEarningHeroCardWidget extends StatelessWidget {
  final DailyEarningDetailsArgs args;

  const DailyEarningHeroCardWidget({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 18.h),
      decoration: myEarningCardDecoration(),
      child: Column(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: AppColors.greenColor500.withValues(alpha: .08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              color: AppColors.greenColor500,
              size: 22.r,
            ),
          ),
          verticalSpace(10),
          Text(
            context.tr('myEarning.${args.dateKey}'),
            style: TextStyles.font12greyColorA3W400,
          ),
          verticalSpace(8),
          Text(args.amount, style: TextStyles.font32greyColor900Weight600),
        ],
      ),
    );
  }
}
