import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/bonuses/logic/bonuses_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class BonusAllCardWidget extends StatelessWidget {
  const BonusAllCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bonuses = context.watch<BonusesCubit>().bonuses;
    final items = bonuses?.items ?? const [];
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myEarning.allBonuses'),
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
              (index) => _BonusEntryRowWidget(
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
                    bonuses?.total ?? 0,
                    bonuses?.currency ?? '',
                    plus: true,
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

class _BonusEntryRowWidget extends StatelessWidget {
  final MoneyLineItem item;
  final bool showDivider;

  const _BonusEntryRowWidget({required this.item, this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: showDivider ? 10.h : 0),
      margin: EdgeInsets.only(bottom: showDivider ? 10.h : 0),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: AppColors.greyColor1001.withValues(alpha: .22),
                  width: .8.w,
                ),
              )
            : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title.isEmpty
                          ? context.tr('myEarning.bonus')
                          : item.title,
                      style: TextStyles.font14greyColor900Weight500,
                    ),
                    if (item.subtitle.isNotEmpty) ...[
                      verticalSpace(3),
                      Text(
                        item.subtitle,
                        style: TextStyles.font12greyColorA3W400,
                      ),
                    ],
                  ],
                ),
              ),
              horizontalSpace(12),
              Text(
                formatMoney(item.amount, item.currency, plus: true),
                style: TextStyles.font14greenColor500Weight600,
              ),
              horizontalSpace(6),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.greyColor100,
                size: 18.r,
              ),
            ],
          ),
          if (item.source.isNotEmpty) ...[
            verticalSpace(10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.greyColorFA,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(item.source, style: TextStyles.font12greyColorA3W400),
            ),
          ],
        ],
      ),
    );
  }
}
