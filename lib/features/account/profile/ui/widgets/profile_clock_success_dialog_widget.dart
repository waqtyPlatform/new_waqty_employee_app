import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

enum ProfileClockSuccessType { clockedIn, clockedOut, breakStarted, breakEnded }

class ProfileClockSuccessDialogWidget extends StatelessWidget {
  final ProfileClockSuccessType type;
  final DateTime actionTime;

  const ProfileClockSuccessDialogWidget({
    super.key,
    required this.type,
    required this.actionTime,
  });

  static Future<void> show(
    BuildContext context, {
    required ProfileClockSuccessType type,
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: AppColors.greyColor3004.withValues(alpha: .4),
      pageBuilder: (_, _, _) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: Center(
            child: ProfileClockSuccessDialogWidget(
              type: type,
              actionTime: DateTime.now(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = _ProfileClockSuccessData.fromType(type);

    return Material(
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 300.w,
            padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80.r,
                  height: 80.r,
                  decoration: BoxDecoration(
                    color: data.outerColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: data.outerColor, width: 16.r),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: data.innerColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(data.icon, color: data.iconColor, size: 40.r),
                  ),
                ),
                verticalSpace(24),
                Text(
                  context.tr(data.titleKey),
                  textAlign: TextAlign.center,
                  style: TextStyles.font18greyColor900Weight600,
                ),
                verticalSpace(8),
                Text(
                  data.message(context, actionTime),
                  textAlign: TextAlign.center,
                  style: TextStyles.font14greyColorA3W400,
                ),
              ],
            ),
          ),
          PositionedDirectional(
            top: 24.h,
            end: 24.w,
            child: InkWell(
              onTap: () => Navigator.pop(context),
              borderRadius: BorderRadius.circular(4.r),
              child: Icon(
                Icons.close,
                size: 18.r,
                color: AppColors.greyColor600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileClockSuccessData {
  final String titleKey;
  final IconData icon;
  final Color outerColor;
  final Color innerColor;
  final Color iconColor;
  final String Function(BuildContext context, DateTime actionTime) message;

  const _ProfileClockSuccessData({
    required this.titleKey,
    required this.icon,
    required this.outerColor,
    required this.innerColor,
    required this.iconColor,
    required this.message,
  });

  factory _ProfileClockSuccessData.fromType(ProfileClockSuccessType type) {
    switch (type) {
      case ProfileClockSuccessType.breakStarted:
        return _ProfileClockSuccessData(
          titleKey: 'profile.breakStarted',
          icon: Icons.free_breakfast_outlined,
          outerColor: AppColors.warningColor1002,
          innerColor: const Color(0xffFEF9C3),
          iconColor: AppColors.warningColor1001,
          message: _timeMessage,
        );
      case ProfileClockSuccessType.breakEnded:
        return _ProfileClockSuccessData(
          titleKey: 'profile.breakEnded',
          icon: Icons.check,
          outerColor: AppColors.successColor0,
          innerColor: AppColors.successColor100,
          iconColor: AppColors.whiteColor,
          message: _timeMessage,
        );
      case ProfileClockSuccessType.clockedIn:
        return _ProfileClockSuccessData(
          titleKey: 'profile.clockedInSuccessfully',
          icon: Icons.check,
          outerColor: AppColors.successColor0,
          innerColor: AppColors.successColor100,
          iconColor: AppColors.whiteColor,
          message: _timeMessage,
        );
      case ProfileClockSuccessType.clockedOut:
        return _ProfileClockSuccessData(
          titleKey: 'profile.clockedOutSuccessfully',
          icon: Icons.check,
          outerColor: AppColors.successColor0,
          innerColor: AppColors.successColor100,
          iconColor: AppColors.whiteColor,
          message: (context, actionTime) {
            final time = _timeMessage(context, actionTime);
            return '$time\n${context.tr('profile.clockedOutMessage')}';
          },
        );
    }
  }

  static String _timeMessage(BuildContext context, DateTime actionTime) {
    return intl.DateFormat(
      'h:mm a',
      context.locale.toString(),
    ).format(actionTime);
  }
}
