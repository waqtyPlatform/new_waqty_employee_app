import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/logic/my_earning_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class RecentEarningsCardWidget extends StatelessWidget {
  const RecentEarningsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final buckets =
        context.watch<MyEarningCubit>().weeklyTrend?.buckets ??
        const <MoneyTrendBucket>[];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myEarning.recent'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(12),
          if (buckets.isEmpty)
            Text(
              context.tr('myEarning.noData'),
              style: TextStyles.font12greyColorA3W400,
            )
          else
            ...buckets
                .take(7)
                .map((item) => _RecentEarningItemWidget(item: item)),
        ],
      ),
    );
  }
}

class _RecentEarningItemWidget extends StatelessWidget {
  final MoneyTrendBucket item;

  const _RecentEarningItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    final date = item.date.isNotEmpty ? item.date : item.weekStart;
    final amount = formatMoney(item.netEarnings, item.currency);
    return GestureDetector(
      onTap: date.isEmpty
          ? null
          : () => Navigator.pushNamed(
              context,
              Routes.dailyEarningDetailsScreen,
              arguments: {
                'date': date,
                'dateKey': item.label.isNotEmpty ? item.label : date,
                'appointmentsKey': item.appointmentsCount.toString(),
                'amount': amount,
              },
            ),
      child: Container(
        constraints: BoxConstraints(minHeight: 50.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.greyColor1001.withValues(alpha: .16),
              width: .8.w,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label.isNotEmpty ? item.label : date,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font14greyColor900Weight600,
                  ),
                  verticalSpace(2),
                  Text(
                    context.tr(
                      'myEarning.appointmentsCount',
                      namedArgs: {'count': item.appointmentsCount.toString()},
                    ),
                    style: TextStyles.font12greyColorA3W400,
                  ),
                ],
              ),
            ),
            horizontalSpace(8),
            Text(
              amount,
              style: item.netEarnings <= 0
                  ? TextStyles.font14greyColor900Weight500.copyWith(
                      color: AppColors.greyColorA3,
                    )
                  : TextStyles.font14greenColor500Weight600,
            ),
          ],
        ),
      ),
    );
  }
}
