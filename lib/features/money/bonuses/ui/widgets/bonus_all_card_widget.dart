import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class BonusAllCardWidget extends StatelessWidget {
  const BonusAllCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
          _BonusEntryRowWidget(
            titleKey: 'punctualityBonus',
            dateKey: 'mar142026',
            amount: '+ EGP 100',
          ),
          _BonusEntryRowWidget(
            titleKey: 'fiveStarReviewStreak',
            dateKey: 'mar102026',
            amount: '+ EGP 75',
          ),
          _BonusEntryRowWidget(
            titleKey: 'monthlyTargetBonus',
            dateKey: 'mar142026',
            amount: '+ EGP 75',
            isExpanded: true,
            showDivider: false,
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
              Text('+ EGP 250', style: TextStyles.font14greenColor500Weight600),
            ],
          ),
        ],
      ),
    );
  }
}

class _BonusEntryRowWidget extends StatelessWidget {
  final String titleKey;
  final String dateKey;
  final String amount;
  final bool isExpanded;
  final bool showDivider;

  const _BonusEntryRowWidget({
    required this.titleKey,
    required this.dateKey,
    required this.amount,
    this.isExpanded = false,
    this.showDivider = true,
  });

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
                      context.tr('myEarning.$titleKey'),
                      style: TextStyles.font14greyColor900Weight500,
                    ),
                    verticalSpace(3),
                    Text(
                      context.tr('myEarning.$dateKey'),
                      style: TextStyles.font12greyColorA3W400,
                    ),
                  ],
                ),
              ),
              horizontalSpace(12),
              Text(amount, style: TextStyles.font14greenColor500Weight600),
              horizontalSpace(6),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColors.greyColor100,
                size: 18.r,
              ),
            ],
          ),
          if (isExpanded) ...[
            verticalSpace(10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.greyColorFA,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                context.tr('myEarning.monthlyTargetBonusDescription'),
                style: TextStyles.font12greyColorA3W400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
