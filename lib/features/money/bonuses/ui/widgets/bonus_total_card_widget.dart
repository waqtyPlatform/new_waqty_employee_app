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

class BonusTotalCardWidget extends StatelessWidget {
  const BonusTotalCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bonuses = context.watch<BonusesCubit>().bonuses;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: myEarningCardDecoration(),
      child: Column(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: const BoxDecoration(
              color: AppColors.warningColor1002,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.workspace_premium_outlined,
              color: AppColors.warningColor1001,
              size: 24.r,
            ),
          ),
          verticalSpace(8),
          Text(
            context.tr('myEarning.totalBonus'),
            style: TextStyles.font12greyColorA3W400,
          ),
          verticalSpace(6),
          Text(
            formatMoney(bonuses?.total ?? 0, bonuses?.currency ?? ''),
            style: TextStyles.font32greyColor900Weight600,
          ),
          if (bonuses?.hasPayoutSplit ?? false) ...[
            verticalSpace(12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: _BonusSplitAmountWidget(
                      label: context.tr('myEarning.paidAmount'),
                      amount: formatMoney(
                        bonuses!.paidAmount,
                        bonuses.currency,
                      ),
                    ),
                  ),
                  horizontalSpace(8),
                  Expanded(
                    child: _BonusSplitAmountWidget(
                      label: context.tr('myEarning.remainingAmount'),
                      amount: formatMoney(
                        bonuses.remainingAmount,
                        bonuses.currency,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BonusSplitAmountWidget extends StatelessWidget {
  final String label;
  final String amount;

  const _BonusSplitAmountWidget({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.greyColorFA,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font10greyColorA3W600,
          ),
          verticalSpace(3),
          Text(
            amount,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font12greyColor900Weight600,
          ),
        ],
      ),
    );
  }
}
