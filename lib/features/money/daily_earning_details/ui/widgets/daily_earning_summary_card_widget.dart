import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';
import 'package:new_waqty_employee_app/features/money/daily_earning_details/logic/daily_earning_details_cubit.dart';
import 'package:new_waqty_employee_app/features/money/shared/data/money_models.dart';

class DailyEarningSummaryCardWidget extends StatelessWidget {
  final String dayEarnings;

  const DailyEarningSummaryCardWidget({super.key, required this.dayEarnings});

  @override
  Widget build(BuildContext context) {
    final details = context.watch<DailyEarningDetailsCubit>().details;
    final currency = details?.currency ?? '';
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myEarning.earningsSummary'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(12),
          _SummaryLineWidget(
            label: context.tr('myEarning.serviceValueGenerated'),
            value: details == null
                ? '-'
                : formatMoney(details.serviceValueGenerated, currency),
          ),
          _SummaryLineWidget(
            label: context.tr('myEarning.commissionEarned'),
            value: details == null
                ? '-'
                : formatMoney(details.commissionEarned, currency),
            valueColor: AppColors.greenColor500,
          ),
          _SummaryLineWidget(
            label: context.tr('myEarning.bonuses'),
            value: details == null ? '-' : formatMoney(details.bonus, currency),
          ),
          _SummaryLineWidget(
            label: context.tr('myEarning.deductions'),
            value: details == null
                ? '-'
                : formatMoney(details.deduction, currency, minus: true),
            valueColor: AppColors.errorColor2002,
          ),
          Divider(color: AppColors.greyColor1001.withValues(alpha: .22)),
          _SummaryLineWidget(
            label: context.tr('myEarning.dayEarnings'),
            value: details == null
                ? dayEarnings
                : formatMoney(details.netEarnings, currency),
            isTotal: true,
            valueColor: AppColors.greenColor500,
          ),
        ],
      ),
    );
  }
}

class _SummaryLineWidget extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  const _SummaryLineWidget({
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style:
                  (isTotal
                          ? TextStyles.font14greyColor900Weight600
                          : TextStyles.font14greyColor500W400)
                      .copyWith(),
            ),
          ),
          horizontalSpace(12),
          Text(
            value,
            style:
                (isTotal
                        ? TextStyles.font14greenColor500Weight600
                        : TextStyles.font14greyColor900Weight500)
                    .copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
