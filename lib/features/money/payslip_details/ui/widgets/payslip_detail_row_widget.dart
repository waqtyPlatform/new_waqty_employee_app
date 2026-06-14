import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class PayslipDetailRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;
  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  const PayslipDetailRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: 30.r,
              height: 30.r,
              decoration: BoxDecoration(
                color:
                    iconBackgroundColor ??
                    AppColors.greenColor500.withValues(alpha: .08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 15.r,
                color: iconColor ?? AppColors.greenColor500,
              ),
            ),
            horizontalSpace(10),
          ],
          Expanded(
            child: Text(
              label,
              style: isTotal
                  ? TextStyles.font14greyColor900Weight600
                  : TextStyles.font14greyColor500W400,
            ),
          ),
          horizontalSpace(12),
          Text(
            value,
            style:
                (isTotal
                        ? TextStyles.font14greyColor900Weight600
                        : TextStyles.font14greyColor900Weight500)
                    .copyWith(color: valueColor ?? AppColors.greyColor900),
          ),
        ],
      ),
    );
  }
}
