import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/my_earning/ui/widgets/my_earning_card_decoration.dart';

class WeeklyTrendCardWidget extends StatelessWidget {
  const WeeklyTrendCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24.r,
                height: 24.r,
                decoration: BoxDecoration(
                  color: AppColors.greenColor500.withValues(alpha: .06),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bar_chart,
                  size: 14.r,
                  color: AppColors.greenColor500,
                ),
              ),
              horizontalSpace(8),
              Expanded(
                child: Text(
                  context.tr('myEarning.weeklyTrend'),
                  style: TextStyles.font14greyColor900Weight600,
                ),
              ),
              Text(
                context.tr('myEarning.details'),
                style: TextStyles.font12greenColor500W600,
              ),
              Icon(
                Icons.chevron_right,
                size: 16.r,
                color: AppColors.greenColor500,
              ),
            ],
          ),
          verticalSpace(12),
          SizedBox(
            height: 118.h,
            width: double.infinity,
            child: CustomPaint(painter: _WeeklyTrendPainter()),
          ),
        ],
      ),
    );
  }
}

class _WeeklyTrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.greyColor100.withValues(alpha: .35)
      ..strokeWidth = 1;
    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr);
    final labelStyle = TextStyle(
      color: AppColors.greyColorA3,
      fontSize: 9.sp,
      fontFamily: 'IBMPlexSansArabic',
    );
    final leftPad = 28.w;
    final bottomPad = 20.h;
    final topPad = 6.h;
    final chartWidth = size.width - leftPad;
    final chartHeight = size.height - bottomPad - topPad;
    final yLabels = ['1600', '1200', '800', '400', '0'];

    for (var index = 0; index < yLabels.length; index++) {
      final y = topPad + (chartHeight / 4) * index;
      _drawDashedLine(
        canvas,
        Offset(leftPad, y),
        Offset(size.width, y),
        gridPaint,
      );
      textPainter.text = TextSpan(text: yLabels[index], style: labelStyle);
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 6.h));
    }

    final points = [
      Offset(leftPad, topPad + chartHeight * .32),
      Offset(leftPad + chartWidth * .33, topPad + chartHeight * .17),
      Offset(leftPad + chartWidth * .66, topPad + chartHeight * .40),
      Offset(leftPad + chartWidth, topPad + chartHeight * .10),
    ];

    final fillPath = Path()..moveTo(points.first.dx, chartHeight + topPad);
    for (final point in points) {
      fillPath.lineTo(point.dx, point.dy);
    }
    fillPath.lineTo(points.last.dx, chartHeight + topPad);
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.greenColor500.withValues(alpha: .12),
            AppColors.greenColor500.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(leftPad, topPad, chartWidth, chartHeight)),
    );

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var index = 1; index < points.length; index++) {
      final prev = points[index - 1];
      final current = points[index];
      linePath.cubicTo(
        prev.dx + chartWidth * .08,
        prev.dy,
        current.dx - chartWidth * .08,
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

    final xLabels = ['W1', 'W2', 'W3', 'W4'];
    for (var index = 0; index < xLabels.length; index++) {
      final x = leftPad + chartWidth * (index / 3);
      textPainter.text = TextSpan(text: xLabels[index], style: labelStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 12.h),
      );
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 4.0;
    const dashSpace = 4.0;
    var currentX = start.dx;
    while (currentX < end.dx) {
      canvas.drawLine(
        Offset(currentX, start.dy),
        Offset((currentX + dashWidth).clamp(start.dx, end.dx), end.dy),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
