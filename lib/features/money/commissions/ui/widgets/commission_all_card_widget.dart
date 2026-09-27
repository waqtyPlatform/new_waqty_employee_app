import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/commissions/logic/commissions_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class CommissionAllCardWidget extends StatelessWidget {
  const CommissionAllCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final commissions = context.watch<CommissionsCubit>().commissions;
    final items = commissions?.items ?? const [];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myEarning.allCommissions'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(12),
          if (items.isEmpty)
            Text(
              context.tr('myEarning.noData'),
              style: TextStyles.font12greyColorA3W400,
            )
          else ...[
            ...List.generate(
              items.length,
              (index) => _CommissionEntryRowWidget(
                item: items[index],
                showDivider: index != items.length - 1,
              ),
            ),
            Divider(color: AppColors.greyColor1001.withValues(alpha: .35)),
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.tr('myEarning.total'),
                    style: TextStyles.font14greyColor900Weight600,
                  ),
                ),
                Text(
                  formatMoney(
                    commissions?.total ?? 0,
                    commissions?.currency ?? '',
                  ),
                  style: TextStyles.font14greenColor500Weight600,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CommissionEntryRowWidget extends StatelessWidget {
  final MoneyLineItem item;
  final bool showDivider;

  const _CommissionEntryRowWidget({
    required this.item,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: showDivider ? 12.h : 0),
      margin: EdgeInsets.only(bottom: showDivider ? 12.h : 0),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: AppColors.greyColor1001.withValues(alpha: .18),
                  width: .8.w,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: AppColors.greenColor500.withValues(alpha: .08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.trending_up,
              color: AppColors.greenColor500,
              size: 16.r,
            ),
          ),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title.isEmpty
                      ? context.tr('myEarning.commission')
                      : item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font14greyColor900Weight500,
                ),
                if (item.subtitle.isNotEmpty) ...[
                  verticalSpace(3),
                  Text(
                    item.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font12greyColorA3W400,
                  ),
                ],
                verticalSpace(6),
                _CommissionStatusChipWidget(item: item),
                if (item.hasPayoutSplit) ...[
                  verticalSpace(6),
                  _CommissionEntrySplitWidget(item: item),
                ],
              ],
            ),
          ),
          horizontalSpace(8),
          Text(
            formatMoney(item.amount, item.currency),
            style: TextStyles.font14greenColor500Weight600,
          ),
        ],
      ),
    );
  }
}

class _CommissionEntrySplitWidget extends StatelessWidget {
  final MoneyLineItem item;

  const _CommissionEntrySplitWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.w,
      runSpacing: 4.h,
      children: [
        _CommissionEntrySplitPillWidget(
          label: context.tr('myEarning.paidAmount'),
          value: formatMoney(item.paidAmount, item.currency),
        ),
        _CommissionEntrySplitPillWidget(
          label: context.tr('myEarning.remainingAmount'),
          value: formatMoney(item.remainingAmount, item.currency),
        ),
      ],
    );
  }
}

class _CommissionEntrySplitPillWidget extends StatelessWidget {
  final String label;
  final String value;

  const _CommissionEntrySplitPillWidget({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.greyColorFA,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        '$label: $value',
        style: TextStyles.font10greyColorA3w400.copyWith(
          color: AppColors.greyColor500,
        ),
      ),
    );
  }
}

class _CommissionStatusChipWidget extends StatelessWidget {
  final MoneyLineItem item;

  const _CommissionStatusChipWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.greenColor500.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        context.tr(
          item.displayStatus == 'pending'
              ? 'myEarning.commissionPendingStatus'
              : item.statusKey,
        ),
        style: TextStyles.font10greyColorA3W600.copyWith(
          color: AppColors.greenColor500,
        ),
      ),
    );
  }
}
