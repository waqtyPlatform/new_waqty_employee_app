import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class ProfileClockSuccessDialogWidget extends StatelessWidget {
  final bool isClockIn;
  final DateTime actionTime;

  const ProfileClockSuccessDialogWidget({
    super.key,
    required this.isClockIn,
    required this.actionTime,
  });

  static Future<void> show(BuildContext context, {required bool isClockIn}) {
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
              isClockIn: isClockIn,
              actionTime: DateTime.now(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleKey = isClockIn
        ? 'profile.clockedInSuccessfully'
        : 'profile.clockedOutSuccessfully';

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
                    color: AppColors.successColor0,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.successColor0,
                      width: 16.r,
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.successColor100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: AppColors.whiteColor,
                      size: 40.r,
                    ),
                  ),
                ),
                verticalSpace(24),
                Text(
                  context.tr(titleKey),
                  textAlign: TextAlign.center,
                  style: TextStyles.font18greyColor900Weight600,
                ),
                verticalSpace(8),
                Text(
                  intl.DateFormat(
                    'h:mm a',
                    context.locale.toString(),
                  ).format(actionTime),
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
