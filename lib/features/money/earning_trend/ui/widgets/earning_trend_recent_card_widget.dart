import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/data/models/earning_trend_item_model.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class EarningTrendRecentCardWidget extends StatelessWidget {
  const EarningTrendRecentCardWidget({super.key});

  static const List<EarningTrendItemModel> _items = [
    EarningTrendItemModel(
      dateKey: 'recentTue3Mar',
      appointmentsKey: 'appointments7',
      amount: 'EGP 680',
    ),
    EarningTrendItemModel(
      dateKey: 'recentMon2Mar',
      appointmentsKey: 'appointments6',
      amount: 'EGP 540',
    ),
    EarningTrendItemModel(
      dateKey: 'recentSun1Mar',
      appointmentsKey: 'appointments5',
      amount: 'EGP 420',
    ),
    EarningTrendItemModel(
      dateKey: 'recentSat28Feb',
      appointmentsKey: 'appointments6',
      amount: 'EGP 540',
    ),
    EarningTrendItemModel(
      dateKey: 'recentFri27Feb',
      appointmentsKey: 'appointments5',
      amount: 'EGP 420',
    ),
    EarningTrendItemModel(
      dateKey: 'recentThu26Feb',
      appointmentsKey: 'appointments7',
      amount: 'EGP 680',
    ),
    EarningTrendItemModel(
      dateKey: 'recentWed25Feb',
      appointmentsKey: 'appointments0',
      amount: '-',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
          ..._items.map((item) => _TrendRecentItemWidget(item: item)),
        ],
      ),
    );
  }
}

class _TrendRecentItemWidget extends StatelessWidget {
  final EarningTrendItemModel item;

  const _TrendRecentItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    final hasAmount = item.amount != '-';
    return GestureDetector(
      onTap: hasAmount
          ? () => Navigator.pushNamed(
              context,
              Routes.dailyEarningDetailsScreen,
              arguments: {
                'dateKey': item.dateKey,
                'appointmentsKey': item.appointmentsKey,
                'amount': item.amount,
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
                    context.tr('myEarning.${item.dateKey}'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font14greyColor900Weight600,
                  ),
                  verticalSpace(2),
                  Text(
                    context.tr('myEarning.${item.appointmentsKey}'),
                    style: TextStyles.font12greyColorA3W400,
                  ),
                ],
              ),
            ),
            horizontalSpace(8),
            Text(
              item.amount,
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
