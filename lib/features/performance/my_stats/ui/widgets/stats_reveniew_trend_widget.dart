import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/models/my_stats_response_model.dart';

class StatsReveniewTrendWidget extends StatelessWidget {
  final List<MyStatsRevenueSeriesModel> series;
  const StatsReveniewTrendWidget({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    final data = series.map((item) => item.numericValue).toList();
    final maxValue = _maxValue(data);

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
            context.tr('myStats.revenueTrend'),
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
                SizedBox(
                  height: 140.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      final val = maxValue - (index * (maxValue / 4));
                      final text = val == val.toInt()
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
                          height: 140.h,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                bottom: 30.h,
                                child: CustomPaint(
                                  painter: _ChartPainter(
                                    data: data,
                                    maxData: maxValue,
                                    lineColor: AppColors.greenColor500,
                                    gradientColor: AppColors.greenColor500,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: series
                                      .map(
                                        (item) => SizedBox(
                                          width: 46.w,
                                          child: Text(
                                            _dateLabel(item),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: TextStyles
                                                .font10greyColorA3w400,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
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

  String _dateLabel(MyStatsRevenueSeriesModel item) {
    final parsed = DateTime.tryParse(item.date);
    if (parsed != null) return '${parsed.month}/${parsed.day}';

    final text = item.label.trim();
    if (text.length <= 6) return text;

    final datePart = RegExp(r'(\d{4})-(\d{1,2})-(\d{1,2})').firstMatch(text);
    if (datePart != null) return '${datePart.group(2)}/${datePart.group(3)}';

    return text;
  }

  double _maxValue(List<double> values) {
    final max = values.fold<double>(
      0,
      (value, item) => item > value ? item : value,
    );
    return max <= 0 ? 1 : max;
  }
}

class _ChartPainter extends CustomPainter {
  final List<double> data;
  final double maxData;
  final Color lineColor;
  final Color gradientColor;

  _ChartPainter({
    required this.data,
    required this.maxData,
    required this.lineColor,
    required this.gradientColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    if (data.length == 1) {
      final paint = Paint()
        ..color = lineColor
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      final y = size.height - (data.first / maxData) * size.height;
      canvas.drawCircle(Offset(size.width / 2, y), 3, paint);
      return;
    }

    final stepX = size.width / (data.length - 1);
    final path = Path();
    final points = <Offset>[];

    for (var i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height - (data[i] / maxData) * size.height;
      points.add(Offset(x, y));
    }

    path.moveTo(points.first.dx, points.first.dy);

    for (var i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPointX = p0.dx + (p1.dx - p0.dx) / 2;
      path.cubicTo(controlPointX, p0.dy, controlPointX, p1.dy, p1.dx, p1.dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          gradientColor.withValues(alpha: 0.15),
          gradientColor.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
