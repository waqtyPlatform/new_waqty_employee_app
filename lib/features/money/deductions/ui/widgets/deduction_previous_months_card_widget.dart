import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class DeductionPreviousMonthsCardWidget extends StatelessWidget {
  const DeductionPreviousMonthsCardWidget({super.key});

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
            context.tr('myEarning.previousMonths'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(12),
          _PreviousDeductionMonthRowWidget(
            monthKey: 'payslipFebruary2026',
            subtitleKey: 'oneDeduction',
            amount: '- EGP 50',
          ),
          _PreviousDeductionMonthRowWidget(
            monthKey: 'payslipJanuary2026',
            subtitleKey: 'noDeductions',
            amount: '-',
          ),
          _PreviousDeductionMonthRowWidget(
            monthKey: 'payslipDecember2025',
            subtitleKey: 'noDeductions',
            amount: '-',
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _PreviousDeductionMonthRowWidget extends StatelessWidget {
  final String monthKey;
  final String subtitleKey;
  final String amount;
  final bool showDivider;

  const _PreviousDeductionMonthRowWidget({
    required this.monthKey,
    required this.subtitleKey,
    required this.amount,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final isAmount = amount.startsWith('- EGP');

    return Container(
      padding: EdgeInsets.only(bottom: showDivider ? 12.h : 0),
      margin: EdgeInsets.only(bottom: showDivider ? 12.h : 0),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: AppColors.greyColor1001.withValues(alpha: .12),
                  width: .8.w,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('myEarning.$monthKey'),
                  style: TextStyles.font14greyColor900Weight500,
                ),
                verticalSpace(3),
                Text(
                  context.tr('myEarning.$subtitleKey'),
                  style: TextStyles.font12greyColorA3W400,
                ),
              ],
            ),
          ),
          horizontalSpace(12),
          Text(
            amount,
            style:
                (isAmount
                        ? TextStyles.font14errorColor2002W500
                        : TextStyles.font14greyColor500W500)
                    .copyWith(color: isAmount ? null : AppColors.greyColorA3),
          ),
        ],
      ),
    );
  }
}
