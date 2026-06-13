import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/biometric_login/ui/widgets/biometric_login_active_status_card_widget.dart';
import 'package:new_waqty_employee_app/features/account/biometric_login/ui/widgets/biometric_login_cancel_button_widget.dart';
import 'package:new_waqty_employee_app/features/account/biometric_login/ui/widgets/biometric_login_device_details_card_widget.dart';
import 'package:new_waqty_employee_app/features/account/biometric_login/ui/widgets/biometric_login_header_widget.dart';
import 'package:new_waqty_employee_app/features/account/biometric_login/ui/widgets/biometric_login_hero_widget.dart';
import 'package:new_waqty_employee_app/features/account/biometric_login/ui/widgets/biometric_login_info_card_widget.dart';
import 'package:new_waqty_employee_app/features/account/biometric_login/ui/widgets/biometric_login_pin_card_widget.dart';
import 'package:new_waqty_employee_app/features/account/biometric_login/ui/widgets/biometric_login_primary_button_widget.dart';
import 'package:new_waqty_employee_app/features/account/biometric_login/ui/widgets/biometric_login_view_data.dart';

class BiometricLoginScreen extends StatelessWidget {
  final BiometricLoginView view;

  const BiometricLoginScreen({super.key, required this.view});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              const BiometricLoginHeaderWidget(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: _BiometricLoginContentWidget(view: view),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _BiometricLoginBottomActionWidget(view: view),
    );
  }
}

class _BiometricLoginContentWidget extends StatelessWidget {
  final BiometricLoginView view;

  const _BiometricLoginContentWidget({required this.view});

  @override
  Widget build(BuildContext context) {
    switch (view) {
      case BiometricLoginView.intro:
        return Column(
          children: [
            BiometricLoginHeroWidget(
              data: view.heroData,
              topPadding: 24,
              iconFrameSize: 150,
            ),
            verticalSpace(18),
            const BiometricLoginInfoCardWidget(),
            verticalSpace(16),
          ],
        );
      case BiometricLoginView.scanning:
        return Column(
          children: [
            verticalSpace(118),
            BiometricLoginHeroWidget(
              data: view.heroData,
              topPadding: 0,
              iconFrameSize: 220,
            ),
            verticalSpace(14),
            BiometricLoginCancelButtonWidget(
              onTap: () => Navigator.maybePop(context),
            ),
          ],
        );
      case BiometricLoginView.verified:
        return Column(
          children: [
            verticalSpace(150),
            BiometricLoginHeroWidget(
              data: view.heroData,
              topPadding: 0,
              iconFrameSize: 140,
            ),
          ],
        );
      case BiometricLoginView.active:
        return Column(
          children: [
            BiometricLoginHeroWidget(data: view.heroData, topPadding: 16),
            verticalSpace(18),
            const BiometricLoginActiveStatusCardWidget(),
            verticalSpace(12),
            const BiometricLoginDeviceDetailsCardWidget(),
            verticalSpace(16),
          ],
        );
      case BiometricLoginView.confirmDisablePin:
        return Column(
          children: [
            BiometricLoginHeroWidget(data: view.heroData, topPadding: 18),
            verticalSpace(14),
            BiometricLoginPinCardWidget(
              onCompletePreview: () =>
                  context.pushNamed(Routes.biometricLoginDisabledScreen),
            ),
          ],
        );
      case BiometricLoginView.disabled:
        return Column(
          children: [
            verticalSpace(78),
            BiometricLoginHeroWidget(
              data: view.heroData,
              topPadding: 0,
              iconFrameSize: 140,
            ),
          ],
        );
    }
  }
}

class _BiometricLoginBottomActionWidget extends StatelessWidget {
  final BiometricLoginView view;

  const _BiometricLoginBottomActionWidget({required this.view});

  @override
  Widget build(BuildContext context) {
    if (view == BiometricLoginView.scanning ||
        view == BiometricLoginView.verified ||
        view == BiometricLoginView.confirmDisablePin ||
        view == BiometricLoginView.disabled) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (view == BiometricLoginView.intro)
              BiometricLoginPrimaryButtonWidget(
                titleKey: 'biometricLogin.enableButton',
                icon: Icons.fingerprint,
                onTap: () =>
                    context.pushNamed(Routes.biometricLoginScanningScreen),
              ),
            if (view == BiometricLoginView.active) ...[
              BiometricLoginPrimaryButtonWidget(
                titleKey: 'biometricLogin.disableButton',
                icon: Icons.close,
                backgroundColor: AppColors.errorColor2002,
                onTap: () =>
                    context.pushNamed(Routes.biometricLoginConfirmPinScreen),
              ),
              verticalSpace(8),
              Text(
                context.tr('biometricLogin.deviceOnlyNote'),
                textAlign: TextAlign.center,
                style: TextStyles.font12greyColorA3W400,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
