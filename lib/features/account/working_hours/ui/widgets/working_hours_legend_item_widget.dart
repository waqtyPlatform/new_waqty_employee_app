import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class WorkingHoursLegendItemWidget extends StatelessWidget {
  final Color color;
  final String label;

  const WorkingHoursLegendItemWidget({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 10.r,
          width: 10.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        horizontalSpace(4),
        Text(label, style: TextStyles.font10greyColorA3w400),
      ],
    );
  }
}
