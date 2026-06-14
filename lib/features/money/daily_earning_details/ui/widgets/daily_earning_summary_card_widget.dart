import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class DailyEarningSummaryCardWidget extends StatelessWidget {
  final String dayEarnings;

  const DailyEarningSummaryCardWidget({super.key, required this.dayEarnings});

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
            context.tr('myEarning.earningsSummary'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(12),
          _SummaryLineWidget(
            label: context.tr('myEarning.serviceRevenue'),
            value: 'EGP 650',
          ),
          _SummaryLineWidget(
            label: '- ${context.tr('myEarning.extraction')}',
            value: '-EGP 110',
            color: AppColors.errorColor2002,
          ),
          _SummaryLineWidget(
            label: context.tr('myEarning.netRevenue'),
            value: 'EGP 540',
          ),
          _SummaryLineWidget(
            label: context.tr('myEarning.commissionPercent'),
            value: 'EGP 27',
            valueColor: AppColors.greenColor500,
          ),
          Divider(color: AppColors.greyColor1001.withValues(alpha: .22)),
          _SummaryLineWidget(
            label: context.tr('myEarning.dayEarnings'),
            value: dayEarnings,
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
  final Color? color;
  final Color? valueColor;
  final bool isTotal;

  const _SummaryLineWidget({
    required this.label,
    required this.value,
    this.color,
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
                      .copyWith(color: color),
            ),
          ),
          horizontalSpace(12),
          Text(
            value,
            style:
                (isTotal
                        ? TextStyles.font14greenColor500Weight600
                        : TextStyles.font14greyColor900Weight500)
                    .copyWith(color: valueColor ?? color),
          ),
        ],
      ),
    );
  }
}
