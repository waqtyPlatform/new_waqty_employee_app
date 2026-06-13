import 'package:flutter/material.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';

enum BiometricLoginView {
  intro,
  scanning,
  verified,
  active,
  confirmDisablePin,
  disabled,
}

class BiometricLoginHeroData {
  final IconData icon;
  final String titleKey;
  final String subtitleKey;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final bool showPulse;
  final bool showCheckBadge;
  final bool showDots;

  const BiometricLoginHeroData({
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
    required this.iconColor,
    required this.backgroundColor,
    this.borderColor = Colors.transparent,
    this.showPulse = false,
    this.showCheckBadge = false,
    this.showDots = false,
  });
}

extension BiometricLoginViewData on BiometricLoginView {
  BiometricLoginHeroData get heroData {
    switch (this) {
      case BiometricLoginView.scanning:
        return const BiometricLoginHeroData(
          icon: Icons.fingerprint,
          titleKey: 'biometricLogin.scanningTitle',
          subtitleKey: 'biometricLogin.scanningSubtitle',
          iconColor: AppColors.greenColor500,
          backgroundColor: AppColors.greenColor5005,
          borderColor: AppColors.greenColor500,
          showPulse: true,
          showDots: true,
        );
      case BiometricLoginView.verified:
        return const BiometricLoginHeroData(
          icon: Icons.check,
          titleKey: 'biometricLogin.verifiedTitle',
          subtitleKey: 'biometricLogin.verifiedSubtitle',
          iconColor: AppColors.greenColor500,
          backgroundColor: AppColors.greenColor5005,
        );
      case BiometricLoginView.active:
        return const BiometricLoginHeroData(
          icon: Icons.fingerprint,
          titleKey: 'biometricLogin.activeTitle',
          subtitleKey: 'biometricLogin.activeSubtitle',
          iconColor: AppColors.greenColor500,
          backgroundColor: AppColors.greenColor5005,
          borderColor: Color(0xff99D4BB),
          showPulse: true,
          showCheckBadge: true,
        );
      case BiometricLoginView.confirmDisablePin:
        return const BiometricLoginHeroData(
          icon: Icons.shield_outlined,
          titleKey: 'biometricLogin.confirmPinTitle',
          subtitleKey: 'biometricLogin.confirmPinSubtitle',
          iconColor: AppColors.errorColor2002,
          backgroundColor: AppColors.errorColor2003,
        );
      case BiometricLoginView.disabled:
        return const BiometricLoginHeroData(
          icon: Icons.fingerprint,
          titleKey: 'biometricLogin.disabledTitle',
          subtitleKey: 'biometricLogin.disabledSubtitle',
          iconColor: AppColors.greyColorE5,
          backgroundColor: AppColors.greyColorFA,
          borderColor: AppColors.greyColorE5,
        );
      case BiometricLoginView.intro:
        return const BiometricLoginHeroData(
          icon: Icons.fingerprint,
          titleKey: 'biometricLogin.introTitle',
          subtitleKey: 'biometricLogin.introSubtitle',
          iconColor: AppColors.greenColor500,
          backgroundColor: AppColors.greyColorFA,
        );
    }
  }
}
