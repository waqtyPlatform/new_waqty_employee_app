import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';

class MoneyLineChartWidget extends StatelessWidget {
  final List<double> values;
  final List<String> xLabels;
  final double height;

  const MoneyLineChartWidget({
    super.key,
    required this.values,
    required this.xLabels,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = values.fold<double>(
      0,
      (max, item) => item > max ? item : max,
    );
    return SizedBox(
      height: height.h,
      width: double.infinity,
      child: CustomPaint(
        painter: _MoneyLineChartPainter(
          values: values,
          xLabels: xLabels,
          yLabels: _yLabels(maxValue),
          maxValue: maxValue <= 0 ? 1 : maxValue,
          textDirection: Directionality.of(context),
        ),
      ),
    );
  }
}

List<String> _yLabels(double maxValue) {
  final max = maxValue <= 0 ? 1 : maxValue;
  return List.generate(5, (index) {
    final value = max - ((max / 4) * index);
    return value.round().toString();
  });
}

class _MoneyLineChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> xLabels;
  final List<String> yLabels;
  final double maxValue;
  final TextDirection textDirection;

  const _MoneyLineChartPainter({
    required this.values,
    required this.xLabels,
    required this.yLabels,
    required this.maxValue,
    required this.textDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final leftPad = textDirection == TextDirection.rtl ? 8.w : 34.w;
    final rightPad = textDirection == TextDirection.rtl ? 34.w : 8.w;
    final topPad = 8.h;
    final bottomPad = 34.h;
    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;
    final gridPaint = Paint()
      ..color = AppColors.greyColor100.withValues(alpha: .42)
      ..strokeWidth = 1;
    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr);
    final labelStyle = TextStyle(
      color: AppColors.greyColorA3,
      fontSize: 9.sp,
      fontFamily: 'IBMPlexSansArabic',
      height: 1.12,
    );

    for (var index = 0; index < yLabels.length; index++) {
      final y = topPad + (chartHeight / (yLabels.length - 1)) * index;
      _drawDashedLine(
        canvas,
        Offset(leftPad, y),
        Offset(size.width - rightPad, y),
        gridPaint,
      );
      textPainter.text = TextSpan(text: yLabels[index], style: labelStyle);
      textPainter.layout(maxWidth: 30.w);
      final dx = textDirection == TextDirection.rtl ? size.width - 28.w : 0.0;
      textPainter.paint(canvas, Offset(dx, y - 6.h));
    }

    if (values.isEmpty) return;

    final chartPoints = <Offset>[
      for (var index = 0; index < values.length; index++)
        Offset(
          leftPad +
              chartWidth *
                  (values.length == 1 ? .5 : index / (values.length - 1)),
          topPad + chartHeight * (1 - (values[index] / maxValue)),
        ),
    ];

    if (chartPoints.length > 1) {
      final fillPath = Path()
        ..moveTo(chartPoints.first.dx, topPad + chartHeight);
      for (final point in chartPoints) {
        fillPath.lineTo(point.dx, point.dy);
      }
      fillPath.lineTo(chartPoints.last.dx, topPad + chartHeight);
      fillPath.close();
      canvas.drawPath(
        fillPath,
        Paint()
          ..shader =
              LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.greenColor500.withValues(alpha: .15),
                  AppColors.greenColor500.withValues(alpha: 0),
                ],
              ).createShader(
                Rect.fromLTWH(leftPad, topPad, chartWidth, chartHeight),
              ),
      );
    }

    final linePath = Path()..moveTo(chartPoints.first.dx, chartPoints.first.dy);
    for (var index = 1; index < chartPoints.length; index++) {
      final prev = chartPoints[index - 1];
      final current = chartPoints[index];
      final controlDistance = chartWidth / values.length * .45;
      linePath.cubicTo(
        prev.dx + controlDistance,
        prev.dy,
        current.dx - controlDistance,
        current.dy,
        current.dx,
        current.dy,
      );
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = AppColors.greenColor500
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.w
        ..strokeCap = StrokeCap.round,
    );

    for (final point in chartPoints) {
      canvas.drawCircle(point, 3.2.r, Paint()..color = AppColors.whiteColor);
      canvas.drawCircle(point, 2.3.r, Paint()..color = AppColors.greenColor500);
    }

    for (var index = 0; index < xLabels.length; index++) {
      final x =
          leftPad +
          chartWidth *
              (xLabels.length == 1 ? .5 : index / (xLabels.length - 1));
      textPainter.text = TextSpan(text: xLabels[index], style: labelStyle);
      textPainter.layout(maxWidth: 42.w);
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 26.h),
      );
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 5.0;
    var currentX = start.dx;
    while (currentX < end.dx) {
      canvas.drawLine(
        Offset(currentX, start.dy),
        Offset(
          (currentX + dashWidth).clamp(start.dx, end.dx).toDouble(),
          end.dy,
        ),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _MoneyLineChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.xLabels != xLabels ||
        oldDelegate.yLabels != yLabels ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.textDirection != textDirection;
  }
}
