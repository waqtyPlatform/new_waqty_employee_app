import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/logic/my_earning_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/money_line_chart_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeeklyTrendCardWidget extends StatelessWidget {
  const WeeklyTrendCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final buckets =
        context.watch<MyEarningCubit>().weeklyTrend?.buckets ?? const [];
    final values = buckets.map((item) => item.netEarnings).toList();
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24.r,
                height: 24.r,
                decoration: BoxDecoration(
                  color: AppColors.greenColor500.withValues(alpha: .06),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bar_chart,
                  size: 14.r,
                  color: AppColors.greenColor500,
                ),
              ),
              horizontalSpace(8),
              Expanded(
                child: Text(
                  context.tr('myEarning.weeklyTrend'),
                  style: TextStyles.font14greyColor900Weight600,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.earningTrendDetailsScreen,
                  arguments: {
                    'month': context.read<MyEarningCubit>().selectedMonth,
                  },
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.tr('myEarning.details'),
                      style: TextStyles.font12greenColor500W600,
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 16.r,
                      color: AppColors.greenColor500,
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(12),
          values.isEmpty
              ? SizedBox(
                  height: 118.h,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      context.tr('myEarning.noData'),
                      style: TextStyles.font12greyColorA3W400,
                    ),
                  ),
                )
              : MoneyLineChartWidget(
                  values: values,
                  xLabels: buckets.map(_bucketLabel).toList(),
                  height: 118,
                ),
        ],
      ),
    );
  }
}

String _bucketLabel(MoneyTrendBucket item) {
  if (item.label.isNotEmpty) return item.label;
  if (item.weekStart.isNotEmpty) return item.weekStart.substring(5);
  return item.date.length >= 10 ? item.date.substring(5) : item.date;
}
