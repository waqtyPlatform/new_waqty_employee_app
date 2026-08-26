import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/logic/earning_trend_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class EarningTrendRecentCardWidget extends StatelessWidget {
  const EarningTrendRecentCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.watch<EarningTrendCubit>().trend?.buckets ?? [];
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
          if (items.isEmpty)
            Text(
              context.tr('myEarning.noData'),
              style: TextStyles.font12greyColorA3W400,
            )
          else
            ...items.map((item) => _TrendRecentItemWidget(item: item)),
        ],
      ),
    );
  }
}

class _TrendRecentItemWidget extends StatelessWidget {
  final MoneyTrendBucket item;

  const _TrendRecentItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    final date = item.date.isNotEmpty ? item.date : item.weekStart;
    final amount = formatMoney(item.netEarnings, item.currency);
    final hasAmount = date.isNotEmpty;
    return GestureDetector(
      onTap: date.isNotEmpty
          ? () => Navigator.pushNamed(
              context,
              Routes.dailyEarningDetailsScreen,
              arguments: {
                'date': date,
                'dateKey': item.label.isNotEmpty ? item.label : date,
                'appointmentsKey': item.appointmentsCount.toString(),
                'amount': amount,
              },
            )
          : null,
      child: Container(
        constraints: BoxConstraints(minHeight: 56.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.greyColor1001.withValues(alpha: .18),
              width: .8.w,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: hasAmount
                    ? AppColors.greenColor500.withValues(alpha: .08)
                    : AppColors.greyColorFA,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.access_time,
                size: 15.r,
                color: hasAmount
                    ? AppColors.greenColor500
                    : AppColors.greyColorA3,
              ),
            ),
            horizontalSpace(10),
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
              style: hasAmount
                  ? TextStyles.font14greenColor500Weight600
                  : TextStyles.font14greyColor900Weight600.copyWith(
                      color: AppColors.greyColorA3,
                    ),
            ),
            if (hasAmount) ...[
              horizontalSpace(8),
              Icon(
                Icons.chevron_right,
                size: 16.r,
                color: AppColors.greenColor500,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
