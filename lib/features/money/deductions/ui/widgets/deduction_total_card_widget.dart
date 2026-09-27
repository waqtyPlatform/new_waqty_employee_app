import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/deductions/logic/deductions_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class DeductionTotalCardWidget extends StatelessWidget {
  const DeductionTotalCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final deductions = context.watch<DeductionsCubit>().deductions;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: myEarningCardDecoration(),
      child: Column(
        children: [
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              color: AppColors.errorColor100.withValues(alpha: .08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.remove_circle_outline,
              color: AppColors.errorColor2002,
              size: 24.r,
            ),
          ),
          verticalSpace(8),
          Text(
            context.tr('myEarning.totalDeductions'),
            style: TextStyles.font12greyColorA3W400,
          ),
          verticalSpace(6),
          Text(
            formatMoney(
              deductions?.total ?? 0,
              deductions?.currency ?? '',
              minus: true,
            ),
            style: TextStyles.font32greyColor900Weight600.copyWith(
              color: AppColors.errorColor2002,
            ),
          ),
          if (deductions?.hasPayoutSplit ?? false) ...[
            verticalSpace(12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: _DeductionSplitAmountWidget(
                      label: context.tr('myEarning.paidAmount'),
                      amount: formatMoney(
                        deductions!.paidAmount,
                        deductions.currency,
                        minus: true,
                      ),
                    ),
                  ),
                  horizontalSpace(8),
                  Expanded(
                    child: _DeductionSplitAmountWidget(
                      label: context.tr('myEarning.remainingAmount'),
                      amount: formatMoney(
                        deductions.remainingAmount,
                        deductions.currency,
                        minus: true,
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

class _DeductionSplitAmountWidget extends StatelessWidget {
  final String label;
  final String amount;

  const _DeductionSplitAmountWidget({
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.errorColor2003,
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
            style: TextStyles.font12greyColor900Weight600.copyWith(
              color: AppColors.errorColor2002,
            ),
          ),
        ],
      ),
    );
  }
}
