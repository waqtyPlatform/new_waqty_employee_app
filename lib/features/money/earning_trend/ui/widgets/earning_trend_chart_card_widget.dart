import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/logic/earning_trend_cubit.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/logic/earning_trend_state.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/money_line_chart_widget.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class EarningTrendChartCardWidget extends StatelessWidget {
  const EarningTrendChartCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningTrendCubit, EarningTrendState>(
      buildWhen: (previous, current) =>
          current is EarningTrendPeriodChangedState ||
          current is EarningTrendSuccessState,
      builder: (context, state) {
        final cubit = context.read<EarningTrendCubit>();
        final isDaily = cubit.selectedPeriod == EarningTrendPeriod.daily;
        final buckets = cubit.trend?.buckets ?? const <MoneyTrendBucket>[];
        final values = buckets.map((item) => item.netEarnings).toList();
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
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
                  Text(
                    context.tr(
                      isDaily
                          ? 'myEarning.dailyEarnings'
                          : 'myEarning.weeklyTrend',
                    ),
                    style: TextStyles.font14greyColor900Weight600,
                  ),
                ],
              ),
              verticalSpace(14),
              if (values.isEmpty)
                SizedBox(
                  height: isDaily ? 184.h : 150.h,
                  child: Center(
                    child: Text(
                      context.tr('myEarning.noData'),
                      style: TextStyles.font12greyColorA3W400,
                    ),
                  ),
                )
              else
                MoneyLineChartWidget(
                  values: values,
                  xLabels: buckets
                      .map((item) => _bucketLabel(item, isDaily))
                      .toList(),
                  height: isDaily ? 184 : 150,
                ),
            ],
          ),
        );
      },
    );
  }
}

String _bucketLabel(MoneyTrendBucket item, bool isDaily) {
  if (item.label.isNotEmpty) return item.label;
  final date = isDaily ? item.date : item.weekStart;
  if (date.length >= 10) {
    return '${date.substring(8, 10)}\n${date.substring(5, 7)}';
  }
  return date;
}
