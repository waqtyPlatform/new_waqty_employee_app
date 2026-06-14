import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class EarningTrendSummaryRowWidget extends StatelessWidget {
  const EarningTrendSummaryRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TrendSummaryCardWidget(
            value: 'EGP 3280',
            label: context.tr('myEarning.total'),
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _TrendSummaryCardWidget(
            value: 'EGP 547',
            label: context.tr('myEarning.avgDay'),
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _TrendSummaryCardWidget(
            value: 'EGP 680',
            label: context.tr('myEarning.bestDay'),
          ),
        ),
      ],
    );
  }
}

class _TrendSummaryCardWidget extends StatelessWidget {
  final String value;
  final String label;

  const _TrendSummaryCardWidget({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      alignment: Alignment.center,
      decoration: myEarningCardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font14greenColor500Weight600,
          ),
          verticalSpace(4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font10greyColorA3W500,
          ),
        ],
      ),
    );
  }
}
