import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/models/my_stats_response_model.dart';

class StatsComparisonWidget extends StatelessWidget {
  final MyStatsComparisonModel comparison;

  const StatsComparisonWidget({super.key, required this.comparison});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.greyColor1001.withValues(alpha: .2),
          width: .8,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myStats.comparison'),
            style: TextStyles.font14greyColor900Weight500,
          ),
          verticalSpace(12),
          _row(
            context,
            metric: context.tr('myStats.metric'),
            current: context.tr('myStats.current'),
            last: context.tr('myStats.last'),
            best: context.tr('myStats.best'),
            isHeader: true,
          ),
          verticalSpace(8),
          _metricRow(
            context,
            context.tr('myStats.appointments'),
            comparison.appointments,
          ),
          ...comparison.revenues.map(
            (revenue) => _metricRow(
              context,
              revenue.currency.isEmpty
                  ? context.tr('myStats.executedServicesValue')
                  : '${context.tr('myStats.executedServicesValue')} : ${revenue.currency}',
              revenue,
              showCurrency: false,
            ),
          ),
          _metricRow(context, context.tr('myStats.rating'), comparison.rating),
        ],
      ),
    );
  }

  Widget _metricRow(
    BuildContext context,
    String metric,
    MyStatsComparisonRowModel row, {
    bool showCurrency = true,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: _row(
        context,
        metric: metric,
        current: _value(row.current, showCurrency ? row.currency : ''),
        last: _value(row.last, showCurrency ? row.currency : ''),
        best: _value(row.best, showCurrency ? row.currency : ''),
      ),
    );
  }

  Widget _row(
    BuildContext context, {
    required String metric,
    required String current,
    required String last,
    required String best,
    bool isHeader = false,
  }) {
    final style = isHeader
        ? TextStyles.font10greyColorA3W500
        : TextStyles.font12greyColorA3W400;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isHeader ? AppColors.greyColor25 : Colors.transparent,
        borderRadius: isHeader ? BorderRadius.circular(6.r) : null,
        border: isHeader
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppColors.greyColor1001.withValues(alpha: .15),
                  width: .8,
                ),
              ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              metric,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: isHeader ? style : TextStyles.font12greyColor900Weight400,
            ),
          ),
          Expanded(
            child: Text(
              current,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              last,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              best,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  String _value(String value, String currency) {
    if (value.isEmpty) return '-';
    return currency.isEmpty ? value : '$currency $value';
  }
}
