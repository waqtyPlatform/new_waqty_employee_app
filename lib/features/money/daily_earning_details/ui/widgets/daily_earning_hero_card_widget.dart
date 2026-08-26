import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/data/models/daily_earning_details_args.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/logic/daily_earning_details_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class DailyEarningHeroCardWidget extends StatelessWidget {
  final DailyEarningDetailsArgs args;

  const DailyEarningHeroCardWidget({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final details = context.watch<DailyEarningDetailsCubit>().details;
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
            _formatDate(context, details?.date ?? args.dateKey),
            style: TextStyles.font12greyColorA3W400,
          ),
          verticalSpace(8),
          Text(
            details == null
                ? args.amount
                : formatMoney(details.netEarnings, details.currency),
            style: TextStyles.font32greyColor900Weight600,
          ),
        ],
      ),
    );
  }
}

String _formatDate(BuildContext context, String value) {
  final date = DateTime.tryParse(value);
  if (date == null) return value;
  return DateFormat('EEE, d MMM', context.locale.toString()).format(date);
}
