import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class BiometricLoginInfoCardWidget extends StatelessWidget {
  const BiometricLoginInfoCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('biometricLogin.howItWorks'),
            style: TextStyles.font16greyColor900Weight600,
          ),
          verticalSpace(14),
          _InfoRowWidget(
            icon: Icons.fingerprint,
            titleKey: 'biometricLogin.fingerprintTitle',
            subtitleKey: 'biometricLogin.fingerprintSubtitle',
          ),
          verticalSpace(14),
          _InfoRowWidget(
            icon: Icons.shield_outlined,
            titleKey: 'biometricLogin.secureTitle',
            subtitleKey: 'biometricLogin.secureSubtitle',
          ),
          verticalSpace(14),
          _InfoRowWidget(
            icon: Icons.vpn_key_outlined,
            titleKey: 'biometricLogin.pinBackupTitle',
            subtitleKey: 'biometricLogin.pinBackupSubtitle',
          ),
        ],
      ),
    );
  }
}

class _InfoRowWidget extends StatelessWidget {
  final IconData icon;
  final String titleKey;
  final String subtitleKey;

  const _InfoRowWidget({
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32.r,
          height: 32.r,
          decoration: const BoxDecoration(
            color: AppColors.greenColor5005,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 17.r, color: AppColors.greenColor500),
        ),
        horizontalSpace(10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr(titleKey),
                style: TextStyles.font14greyColor900Weight600,
              ),
              verticalSpace(2),
              Text(
                context.tr(subtitleKey),
                style: TextStyles.font12greyColorA3W400,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
