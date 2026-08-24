import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/models/my_stats_response_model.dart';

class StatsUtilizationDetailsWidget extends StatelessWidget {
  final MyStatsUtilizationKpiModel utilization;
  final bool hasEstimatedData;

  const StatsUtilizationDetailsWidget({
    super.key,
    required this.utilization,
    required this.hasEstimatedData,
  });

  @override
  Widget build(BuildContext context) {
    return _StatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.tr('myStats.utilizationDetails'),
                style: TextStyles.font14greyColor900Weight500,
              ),
              if (hasEstimatedData) ...[
                horizontalSpace(6),
                Tooltip(
                  message: context.tr('myStats.estimatedData'),
                  child: Icon(
                    Icons.info_outline,
                    size: 16.r,
                    color: AppColors.greyColorA3,
                  ),
                ),
              ],
            ],
          ),
          verticalSpace(12),
          Row(
            children: [
              SizedBox(
                width: 96.r,
                height: 96.r,
                child: CustomPaint(
                  painter: _UtilizationPainter(
                    percentage: utilization.percentage.clamp(0, 100),
                  ),
                  child: Center(
                    child: Text(
                      '${utilization.percentage.toStringAsFixed(0)}%',
                      style: TextStyles.font24greyColor900Weight600,
                    ),
                  ),
                ),
              ),
              horizontalSpace(12),
              Expanded(
                child: Text(
                  context.tr(
                    'myStats.workedHoursOfAvailable',
                    namedArgs: {
                      'worked': _hours(utilization.occupiedMinutes),
                      'available': _hours(utilization.availableMinutes),
                    },
                  ),
                  style: TextStyles.font14greyColor500W400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _hours(int minutes) {
    final hours = minutes / 60;
    return hours == hours.roundToDouble()
        ? '${hours.toStringAsFixed(0)}h'
        : '${hours.toStringAsFixed(1)}h';
  }
}

class _UtilizationPainter extends CustomPainter {
  final double percentage;

  const _UtilizationPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 8.r;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final backgroundPaint = Paint()
      ..color = AppColors.greyColor50
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = AppColors.greenColor500
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawArc(
      rect,
      -1.5708,
      6.28318 * (percentage / 100),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _UtilizationPainter oldDelegate) {
    return oldDelegate.percentage != percentage;
  }
}

class _StatsCard extends StatelessWidget {
  final Widget child;

  const _StatsCard({required this.child});

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
      child: child,
    );
  }
}
