import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class BiometricLoginDeviceDetailsCardWidget extends StatelessWidget {
  const BiometricLoginDeviceDetailsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColorFA, width: .8.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _DetailRowWidget(
            labelKey: 'biometricLogin.device',
            valueKey: 'biometricLogin.deviceValue',
          ),
          const Divider(color: AppColors.greyColorF5),
          _DetailRowWidget(
            labelKey: 'biometricLogin.method',
            valueKey: 'biometricLogin.methodValue',
          ),
          const Divider(color: AppColors.greyColorF5),
          _DetailRowWidget(
            labelKey: 'biometricLogin.enabled',
            valueKey: 'biometricLogin.enabledValue',
          ),
        ],
      ),
    );
  }
}

class _DetailRowWidget extends StatelessWidget {
  final String labelKey;
  final String valueKey;

  const _DetailRowWidget({required this.labelKey, required this.valueKey});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.h,
      child: Row(
        children: [
          Icon(Icons.phone_iphone, size: 16.r, color: AppColors.greyColorA3),
          horizontalSpace(8),
          Text(context.tr(labelKey), style: TextStyles.font14greyColorA3W400),
          const Spacer(),
          Flexible(
            child: Text(
              context.tr(valueKey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: TextStyles.font14greyColor900Weight500,
            ),
          ),
        ],
      ),
    );
  }
}
