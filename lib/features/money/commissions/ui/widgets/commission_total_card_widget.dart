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

class CommissionTotalCardWidget extends StatelessWidget {
  const CommissionTotalCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final commissions = context.watch<CommissionsCubit>().commissions;
    final currency = commissions?.currency ?? '';
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
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: AppColors.greenColor500.withValues(alpha: .08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.trending_up,
                  color: AppColors.greenColor500,
                  size: 22.r,
                ),
              ),
              horizontalSpace(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('myEarning.totalCommissions'),
                      style: TextStyles.font12greyColorA3W400,
                    ),
                    verticalSpace(4),
                    Text(
                      formatMoney(commissions?.total ?? 0, currency),
                      style: TextStyles.font32greyColor900Weight600.copyWith(
                        color: AppColors.greenColor500,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          verticalSpace(16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.greyColorFA,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              children: [
                _CommissionSummaryRowWidget(
                  label: context.tr('myEarning.commissionPendingStatus'),
                  amount: formatMoney(commissions?.pending ?? 0, currency),
                  color: AppColors.warningColor1001,
                ),
                _CommissionSummaryRowWidget(
                  label: context.tr('myEarning.commissionEarned'),
                  amount: formatMoney(commissions?.earned ?? 0, currency),
                  color: AppColors.greenColor500,
                ),
                _CommissionSummaryRowWidget(
                  label: context.tr('myEarning.payoutIncluded'),
                  amount: formatMoney(commissions?.included ?? 0, currency),
                  color: AppColors.blueColor506,
                ),
                _CommissionSummaryRowWidget(
                  label: context.tr('myEarning.approved'),
                  amount: formatMoney(commissions?.approved ?? 0, currency),
                  color: AppColors.greenColor500,
                ),
                _CommissionSummaryRowWidget(
                  label: context.tr('myEarning.payoutPaid'),
                  amount: formatMoney(commissions?.paid ?? 0, currency),
                  color: AppColors.greenColor500,
                ),
                if ((commissions?.reversed ?? 0) > 0)
                  _CommissionSummaryRowWidget(
                    label: context.tr('myEarning.reversed'),
                    amount: formatMoney(
                      commissions?.reversed ?? 0,
                      currency,
                      minus: true,
                    ),
                    color: AppColors.errorColor2002,
                    showDivider: false,
                  )
                else
                  _CommissionSummaryRowWidget(
                    label: context.tr('myEarning.reversed'),
                    amount: formatMoney(0, currency),
                    color: AppColors.errorColor2002,
                    showDivider: false,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommissionSummaryRowWidget extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final bool showDivider;

  const _CommissionSummaryRowWidget({
    required this.label,
    required this.amount,
    required this.color,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: showDivider ? 10.h : 0),
      child: Container(
        padding: EdgeInsets.only(bottom: showDivider ? 10.h : 0),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(
                  bottom: BorderSide(
                    color: AppColors.greyColor1001.withValues(alpha: .14),
                    width: .8.w,
                  ),
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 8.r,
              height: 8.r,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            horizontalSpace(8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.font12greyColorA3W400,
              ),
            ),
            horizontalSpace(8),
            Text(
              amount,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.font12greyColor900Weight600.copyWith(
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
