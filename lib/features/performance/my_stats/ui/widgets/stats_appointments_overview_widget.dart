import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/models/my_stats_response_model.dart';

class StatsAppointmentsOverviewWidget extends StatelessWidget {
  final List<MyStatsAppointmentsSeriesModel> series;
  const StatsAppointmentsOverviewWidget({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    final maxValue = _maxValue;
    return Container(
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
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .05),
            blurRadius: 3,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myStats.appointmentsOverview'),
            style: TextStyles.font14greyColor900Weight500,
          ),
          verticalSpace(12),
          if (series.isEmpty)
            SizedBox(
              height: 140.h,
              child: Center(
                child: Text(
                  context.tr('myStats.emptyChart'),
                  style: TextStyles.font12greyColorA3W400,
                ),
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Y-axis labels
                SizedBox(
                  height: 140.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      double val = maxValue - (index * (maxValue / 4));
                      String text = val == val.toInt()
                          ? val.toInt().toString()
                          : val.toStringAsFixed(1);
                      return Text(
                        text,
                        style: TextStyles.font10greyColorA3w400,
                      );
                    }),
                  ),
                ),
                horizontalSpace(12),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final chartWidth = math.max(
                        constraints.maxWidth,
                        series.length * 48.w,
                      );
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: chartWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: series
                                .map(
                                  (item) => _buildDayColumn(
                                    _dateLabel(item),
                                    item.appointmentsCount,
                                    maxValue,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _dateLabel(MyStatsAppointmentsSeriesModel item) {
    final parsed = DateTime.tryParse(item.date);
    if (parsed != null) return '${parsed.month}/${parsed.day}';

    final text = item.label.trim();
    if (text.length <= 6) return text;

    final datePart = RegExp(r'(\d{4})-(\d{1,2})-(\d{1,2})').firstMatch(text);
    if (datePart != null) return '${datePart.group(2)}/${datePart.group(3)}';

    return text;
  }

  double get _maxValue {
    final max = series.fold<int>(
      0,
      (value, item) =>
          item.appointmentsCount > value ? item.appointmentsCount : value,
    );
    return max <= 0 ? 1 : max.toDouble();
  }

  Widget _buildDayColumn(String label, int value1, double height) {
    final double heightPerUnit = 140.h / height;

    return SizedBox(
      width: 46.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 140.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: value1 * heightPerUnit,
                  width: 18.w,
                  decoration: BoxDecoration(
                    color: AppColors.greenColor500,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.r),
                      topRight: Radius.circular(4.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyles.font10greyColorA3w400,
          ),
        ],
      ),
    );
  }
}
