import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/logic/app_pin_cubit.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/logic/app_pin_state.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/app_pin_button_widget.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/app_pin_header_widget.dart';

class BiometricSettingsScreen extends StatelessWidget {
  const BiometricSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: BlocConsumer<AppPinCubit, AppPinState>(
            listener: _listener,
            buildWhen: (previous, current) {
              return current is AppPinLoadingState ||
                  current is AppPinStatusChangedState ||
                  current is BiometricCheckingState ||
                  current is BiometricEnabledState ||
                  current is BiometricDisabledState ||
                  current is BiometricNotEnrolledState ||
                  current is BiometricNotSupportedState ||
                  current is BiometricAuthFailureState ||
                  current is AppPinErrorState;
            },
            builder: (context, state) {
              final cubit = AppPinCubit.get(context);
              final isScanning = state is BiometricCheckingState;
              final showOpenSettings =
                  state is BiometricNotEnrolledState ||
                  state is BiometricNotSupportedState ||
                  state is BiometricAuthFailureState;

              return Column(
                children: [
                  AppPinHeaderWidget(
                    title: context.tr('profile.biometricLogin'),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h, bottom: 18.h),
                        child: isScanning
                            ? const _BiometricScanningView()
                            : cubit.isBiometricEnabled
                            ? _BiometricActiveView(cubit: cubit)
                            : const _BiometricIntroView(),
                      ),
                    ),
                  ),
                  if (!isScanning)
                    _BiometricBottomActionWidget(
                      cubit: cubit,
                      showOpenSettings: showOpenSettings,
                    ),
                  verticalSpace(12),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context, AppPinState state) {
    if (state is BiometricEnabledState) {
      AppConstant.toast(
        context.tr('biometricLogin.enabledSuccess'),
        true,
        context,
      );
    } else if (state is BiometricDisabledState) {
      AppConstant.toast(
        context.tr('biometricLogin.disabledSuccess'),
        true,
        context,
      );
    } else if (state is AppPinErrorState) {
      AppConstant.toast(context.tr(state.messageKey), false, context);
    } else if (state is BiometricAuthFailureState) {
      AppConstant.toast(context.tr(state.messageKey), false, context);
    } else if (state is BiometricNotEnrolledState) {
      AppConstant.toast(
        context.tr('biometricLogin.notEnrolledMessage'),
        false,
        context,
      );
    } else if (state is BiometricNotSupportedState) {
      AppConstant.toast(
        context.tr('biometricLogin.notSupportedMessage'),
        false,
        context,
      );
    }
  }
}

class _BiometricIntroView extends StatelessWidget {
  const _BiometricIntroView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _BiometricHeroWidget(
          icon: Icons.fingerprint,
          iconColor: AppColors.greyColorE5,
          backgroundColor: AppColors.greyColorFA,
          borderColor: AppColors.greyColorE5,
        ),
        verticalSpace(26),
        Text(
          context.tr('biometricLogin.introTitle'),
          textAlign: TextAlign.center,
          style: TextStyles.font18greyColor900Weight600,
        ),
        verticalSpace(4),
        Text(
          context.tr('biometricLogin.introSubtitle'),
          textAlign: TextAlign.center,
          style: TextStyles.font14greyColorA3W400,
        ),
        verticalSpace(20),
        const _BiometricHowItWorksCardWidget(),
      ],
    );
  }
}

class _BiometricActiveView extends StatelessWidget {
  final AppPinCubit cubit;

  const _BiometricActiveView({required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _BiometricHeroWidget(
          icon: Icons.fingerprint,
          iconColor: AppColors.greenColor500,
          backgroundColor: AppColors.greenColor5005,
          borderColor: AppColors.greenColor500,
          badgeIcon: Icons.check,
          badgeColor: AppColors.greenColor500,
        ),
        verticalSpace(18),
        Text(
          context.tr('biometricLogin.activeTitle'),
          textAlign: TextAlign.center,
          style: TextStyles.font18greyColor900Weight600,
        ),
        verticalSpace(4),
        Text(
          context.tr('biometricLogin.activeSubtitle'),
          textAlign: TextAlign.center,
          style: TextStyles.font14greyColorA3W400,
        ),
        verticalSpace(18),
        _BiometricActiveStatusCardWidget(
          lastUsedText: cubit.biometricLastUsedText,
        ),
        verticalSpace(12),
        _BiometricDeviceDetailsCardWidget(
          deviceName: cubit.biometricDeviceName,
          method: cubit.biometricMethod,
          enabledAtText: cubit.biometricEnabledAtText,
        ),
      ],
    );
  }
}

class _BiometricScanningView extends StatelessWidget {
  const _BiometricScanningView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 96.h),
      child: Column(
        children: [
          SizedBox(
            width: 220.r,
            height: 220.r,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _BiometricRing(size: 192.r, opacity: .12),
                _BiometricRing(size: 144.r, opacity: .23),
                _BiometricRing(size: 97.r, opacity: .29),
                Container(
                  width: 97.r,
                  height: 97.r,
                  decoration: const BoxDecoration(
                    color: AppColors.greenColor5005,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.fingerprint,
                    size: 50.r,
                    color: AppColors.greenColor500,
                  ),
                ),
              ],
            ),
          ),
          verticalSpace(12),
          Text(
            context.tr('biometricLogin.scanningTitle'),
            textAlign: TextAlign.center,
            style: TextStyles.font16greyColor900Weight600,
          ),
          verticalSpace(4),
          Text(
            context.tr('biometricLogin.scanningSubtitle'),
            textAlign: TextAlign.center,
            style: TextStyles.font14greyColorA3W400,
          ),
          verticalSpace(7),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Container(
                width: index == 2 ? 9.w : 5.r,
                height: 5.r,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: AppColors.greenColor500.withValues(
                    alpha: index == 0
                        ? .99
                        : index == 1
                        ? .56
                        : .21,
                  ),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
          ),
          verticalSpace(12),
          TextButton.icon(
            onPressed: () => Navigator.maybePop(context),
            icon: Icon(Icons.close, size: 16.r, color: AppColors.greyColorA3),
            label: Text(
              context.tr('biometricLogin.cancel'),
              style: TextStyles.font14greyColorA3W400,
            ),
          ),
        ],
      ),
    );
  }
}

class _BiometricBottomActionWidget extends StatelessWidget {
  final AppPinCubit cubit;
  final bool showOpenSettings;

  const _BiometricBottomActionWidget({
    required this.cubit,
    required this.showOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showOpenSettings) ...[
          AppPinButtonWidget(
            text: context.tr('biometricLogin.openSettings'),
            backgroundColor: AppColors.greyColorFA,
            textColor: AppColors.greyColor900,
            borderColor: AppColors.greyColorE5,
            onTap: () => cubit.openSecuritySettings(),
          ),
          verticalSpace(8),
        ],
        if (cubit.isBiometricEnabled) ...[
          AppPinButtonWidget(
            text: context.tr('biometricLogin.disableButton'),
            backgroundColor: AppColors.errorColor2002,
            onTap: () => _onDisable(context),
          ),
          verticalSpace(8),
          Text(
            context.tr('biometricLogin.deviceOnlyNote'),
            textAlign: TextAlign.center,
            style: TextStyles.font12greyColorA3W400,
          ),
        ] else
          AppPinButtonWidget(
            text: context.tr('biometricLogin.enableButton'),
            onTap: () => cubit.isPinEnabled
                ? context
                      .pushNamed(Routes.enableBiometricScreen)
                      .then((_) => cubit.loadSecuritySettings())
                : cubit.enableBiometric(),
          ),
      ],
    );
  }

  void _onDisable(BuildContext context) {
    if (cubit.isPinEnabled) {
      context
          .pushNamed(Routes.disableBiometricScreen)
          .then((_) => cubit.loadSecuritySettings());
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.whiteColor,
        title: Text(
          context.tr('biometricLogin.disableConfirmTitle'),
          style: TextStyles.font18greyColor900Weight600,
        ),
        content: Text(
          context.tr('biometricLogin.disableConfirmMessage'),
          style: TextStyles.font14greyColor500W400,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              context.tr('appPin.cancel'),
              style: TextStyles.font14greyColor500W500,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              cubit.disableBiometric(confirmed: true);
            },
            child: Text(
              context.tr('appPin.confirm'),
              style: TextStyles.font14errorColor2002W500,
            ),
          ),
        ],
      ),
    );
  }
}

class _BiometricHeroWidget extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final IconData? badgeIcon;
  final Color? badgeColor;

  const _BiometricHeroWidget({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
    this.badgeIcon,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140.r,
      height: 140.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 136.r,
            height: 136.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor.withValues(alpha: .14)),
            ),
          ),
          Container(
            width: 90.r,
            height: 90.r,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor.withValues(alpha: .45)),
            ),
            child: Icon(icon, size: 46.r, color: iconColor),
          ),
          if (badgeIcon != null)
            PositionedDirectional(
              end: 20.w,
              bottom: 22.h,
              child: Container(
                width: 24.r,
                height: 24.r,
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(badgeIcon, size: 14.r, color: AppColors.whiteColor),
              ),
            ),
        ],
      ),
    );
  }
}

class _BiometricRing extends StatelessWidget {
  final double size;
  final double opacity;

  const _BiometricRing({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.greenColor500.withValues(alpha: opacity),
        ),
      ),
    );
  }
}

class _BiometricHowItWorksCardWidget extends StatelessWidget {
  const _BiometricHowItWorksCardWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('biometricLogin.howItWorks'),
            style: TextStyles.font10greyColorA3W600,
          ),
          verticalSpace(14),
          _HowItWorksItemWidget(
            icon: Icons.fingerprint,
            titleKey: 'biometricLogin.fingerprintTitle',
            subtitleKey: 'biometricLogin.fingerprintSubtitle',
          ),
          verticalSpace(14),
          _HowItWorksItemWidget(
            icon: Icons.shield_outlined,
            titleKey: 'biometricLogin.secureTitle',
            subtitleKey: 'biometricLogin.secureSubtitle',
          ),
          verticalSpace(14),
          _HowItWorksItemWidget(
            icon: Icons.key_outlined,
            titleKey: 'biometricLogin.pinBackupTitle',
            subtitleKey: 'biometricLogin.pinBackupSubtitle',
          ),
        ],
      ),
    );
  }
}

class _HowItWorksItemWidget extends StatelessWidget {
  final IconData icon;
  final String titleKey;
  final String subtitleKey;

  const _HowItWorksItemWidget({
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16.r,
          backgroundColor: AppColors.greenColor505,
          child: Icon(icon, size: 16.r, color: AppColors.greenColor500),
        ),
        horizontalSpace(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr(titleKey),
                style: TextStyles.font14greyColor900Weight500,
              ),
              verticalSpace(3),
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

class _BiometricActiveStatusCardWidget extends StatelessWidget {
  final String lastUsedText;

  const _BiometricActiveStatusCardWidget({required this.lastUsedText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.greenColor5005,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.greenColor500.withValues(alpha: .3),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: AppColors.greenColor50055,
            child: Icon(
              Icons.check_circle_outline,
              color: AppColors.greenColor500,
              size: 17.r,
            ),
          ),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('biometricLogin.activeOnDevice'),
                  style: TextStyles.font14greenColor500Weight600,
                ),
                verticalSpace(3),
                Text(
                  lastUsedText.isEmpty
                      ? context.tr('biometricLogin.lastUsedUnavailable')
                      : context.tr(
                          'biometricLogin.lastUsedWithValue',
                          namedArgs: {'value': lastUsedText},
                        ),
                  style: TextStyles.font12greyColorA3W400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BiometricDeviceDetailsCardWidget extends StatelessWidget {
  final String deviceName;
  final String method;
  final String enabledAtText;

  const _BiometricDeviceDetailsCardWidget({
    required this.deviceName,
    required this.method,
    required this.enabledAtText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _BiometricDetailRowWidget(
            labelKey: 'biometricLogin.device',
            value: deviceName,
          ),
          const Divider(color: AppColors.greyColorF5, height: .8),
          _BiometricDetailRowWidget(
            labelKey: 'biometricLogin.method',
            value: method,
          ),
          const Divider(color: AppColors.greyColorF5, height: .8),
          _BiometricDetailRowWidget(
            labelKey: 'biometricLogin.enabled',
            value: enabledAtText.isEmpty
                ? context.tr('biometricLogin.enabledUnavailable')
                : enabledAtText,
          ),
        ],
      ),
    );
  }
}

class _BiometricDetailRowWidget extends StatelessWidget {
  final String labelKey;
  final String value;

  const _BiometricDetailRowWidget({
    required this.labelKey,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Icon(Icons.phone_iphone, color: AppColors.greyColorA3, size: 16.r),
          horizontalSpace(8),
          Text(context.tr(labelKey), style: TextStyles.font14greyColorA3W400),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.font14greyColor900Weight500,
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
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
  );
}
