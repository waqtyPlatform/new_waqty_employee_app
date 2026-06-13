import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class BiometricLoginCancelButtonWidget extends StatelessWidget {
  final VoidCallback onTap;

  const BiometricLoginCancelButtonWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.close, size: 16.r, color: AppColors.greyColorA3),
          horizontalSpace(4),
          Text(
            context.tr('biometricLogin.cancel'),
            style: TextStyles.font14greyColorA3W400,
          ),
        ],
      ),
    );
  }
}
