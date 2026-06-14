import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/logic/earning_trend_cubit.dart';
import 'package:new_waqty_employee_app/features/money/earning_trend/logic/earning_trend_state.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class EarningTrendChartCardWidget extends StatelessWidget {
  const EarningTrendChartCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EarningTrendCubit, EarningTrendState>(
      buildWhen: (previous, current) =>
          current is EarningTrendPeriodChangedState,
      builder: (context, state) {
        final period = context.read<EarningTrendCubit>().selectedPeriod;
        final isDaily = period == EarningTrendPeriod.daily;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: myEarningCardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bar_chart,
                    size: 16.r,
                    color: AppColors.greenColor500,
                  ),
                  horizontalSpace(8),
                  Text(
                    context.tr(
                      isDaily
                          ? 'myEarning.dailyEarnings'
                          : 'myEarning.weeklyTrend',
                    ),
                    style: TextStyles.font14greyColor900Weight500,
                  ),
                ],
              ),
              verticalSpace(14),
              SizedBox(
                height: isDaily ? 200.h : 150.h,
                width: double.infinity,
                child: CustomPaint(
                  painter: _EarningTrendPainter(
                    points: isDaily
                        ? const [680, 420, 540, 420, 540, 680]
                        : const [1050, 1320, 950, 1480],
                    xLabels: isDaily
                        ? const [
                            '26\nFeb',
                            '27\nFeb',
                            '28\nFeb',
                            '1\nMar',
                            '2\nMar',
                            '3\nMar',
                          ]
                        : const ['W1', 'W2', 'W3', 'W4'],
                    yLabels: isDaily
                        ? const ['800', '600', '400', '200', '0']
                        : const ['1600', '800', '400', '0'],
                    maxValue: isDaily ? 800 : 1600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EarningTrendPainter extends CustomPainter {
  final List<double> points;
  final List<String> xLabels;
  final List<String> yLabels;
  final double maxValue;

  const _EarningTrendPainter({
    required this.points,
    required this.xLabels,
    required this.yLabels,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final leftPad = 34.w;
    final rightPad = 8.w;
    final topPad = 6.h;
    final bottomPad = 28.h;
    final chartWidth = size.width - leftPad - rightPad;
    final chartHeight = size.height - topPad - bottomPad;
    final gridPaint = Paint()
      ..color = AppColors.greyColor100.withValues(alpha: .38)
      ..strokeWidth = 1;
    final textPainter = TextPainter(textDirection: ui.TextDirection.ltr);
    final labelStyle = TextStyle(
      color: AppColors.greyColorA3,
      fontSize: 10.sp,
      fontFamily: 'IBMPlexSansArabic',
      height: 1.1,
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
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 7.h));
    }

    final chartPoints = <Offset>[
      for (var index = 0; index < points.length; index++)
        Offset(
          leftPad + chartWidth * (index / (points.length - 1)),
          topPad + chartHeight * (1 - (points[index] / maxValue)),
        ),
    ];

    final fillPath = Path()..moveTo(chartPoints.first.dx, topPad + chartHeight);
    for (final point in chartPoints) {
      fillPath.lineTo(point.dx, point.dy);
    }
    fillPath.lineTo(chartPoints.last.dx, topPad + chartHeight);
    fillPath.close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.greenColor500.withValues(alpha: .15),
            AppColors.greenColor500.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromLTWH(leftPad, topPad, chartWidth, chartHeight)),
    );

    final linePath = Path()..moveTo(chartPoints.first.dx, chartPoints.first.dy);
    for (var index = 1; index < chartPoints.length; index++) {
      final prev = chartPoints[index - 1];
      final current = chartPoints[index];
      final controlDistance = chartWidth / points.length * .45;
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
      canvas.drawCircle(point, 3.4.r, Paint()..color = AppColors.whiteColor);
      canvas.drawCircle(point, 2.5.r, Paint()..color = AppColors.greenColor500);
    }

    for (var index = 0; index < xLabels.length; index++) {
      final x = leftPad + chartWidth * (index / (xLabels.length - 1));
      textPainter.text = TextSpan(text: xLabels[index], style: labelStyle);
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, size.height - 20.h),
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
        Offset((currentX + dashWidth).clamp(start.dx, end.dx), end.dy),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _EarningTrendPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.xLabels != xLabels ||
        oldDelegate.yLabels != yLabels ||
        oldDelegate.maxValue != maxValue;
  }
}
