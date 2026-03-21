import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class StatsReveniewTrendWidget extends StatelessWidget {
  final double maxValue;
  // final List<double> data;
  const StatsReveniewTrendWidget({
    super.key,
    required this.maxValue,
    // required this.data,
  });

  @override
  Widget build(BuildContext context) {
    // Example data based on the provided design image
    final List<double> data = [1200, 1450, 0, 1800, 950, 1350, 0];

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
          Text('Revenue Trend', style: TextStyles.font14greyColor900Weight500),
          verticalSpace(12),
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
                    return Text(text, style: TextStyles.font10greyColorA3w400);
                  }),
                ),
              ),
              horizontalSpace(12),
              // Graph area
              Expanded(
                child: SizedBox(
                  height: 140.h,
                  child: Stack(
                    children: [
                      // Render the chart filling available height and width
                      Positioned.fill(
                        bottom: 30.h, // Leave space for X-axis labels
                        child: CustomPaint(
                          painter: _ChartPainter(
                            data: data,
                            maxData: maxValue,
                            lineColor: AppColors.greenColor500,
                            gradientColor: AppColors.greenColor500,
                          ),
                        ),
                      ),
                      // Align X-axis labels at the bottom
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children:
                              ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                                  .map(
                                    (e) => Text(
                                      e,
                                      style: TextStyles.font10greyColorA3w400,
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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

    final double stepX = size.width / (data.length - 1);

    final Path path = Path();
    final List<Offset> points = [];

    for (int i = 0; i < data.length; i++) {
      final double x = i * stepX;
      // y is inverted because 0 is at the top of the canvas
      final double y = size.height - (data[i] / maxData) * size.height;
      points.add(Offset(x, y));
    }

    path.moveTo(points.first.dx, points.first.dy);

    // Apply cubic bezier curves to smooth the lines connecting the data points
    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];

      // A simple control point halfway on the x-axis gives a smooth S-curve
      final double controlPointX = p0.dx + (p1.dx - p0.dx) / 2;

      path.cubicTo(controlPointX, p0.dy, controlPointX, p1.dy, p1.dx, p1.dy);
    }

    // Draw the subtle gradient fill below the line
    final Path fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          gradientColor.withValues(alpha: 0.15),
          gradientColor.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Draw the green line itself
    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
