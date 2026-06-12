import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_clock_success_dialog_widget.dart';

class ProfileClockActionDialogWidget extends StatelessWidget {
  final bool isClockedIn;

  const ProfileClockActionDialogWidget({super.key, required this.isClockedIn});

  static Future<void> show(BuildContext context, {required bool isClockedIn}) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: AppColors.greyColor3004.withValues(alpha: .4),
      pageBuilder: (_, _, _) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          child: Center(
            child: ProfileClockActionDialogWidget(isClockedIn: isClockedIn),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final actionKey = isClockedIn ? 'profile.clockOut' : 'profile.clockIn';
    final actionColor = isClockedIn
        ? AppColors.errorColor100
        : AppColors.greenColor500;
    final now = DateTime.now();

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300.w,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.greyColorFA, width: .8.w),
          boxShadow: [
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: .1),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AppColors.blackColor.withValues(alpha: .06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ClockDialogHeaderWidget(title: context.tr(actionKey)),
            verticalSpace(12),
            Text(
              intl.DateFormat(
                'h:mm:ss a',
                context.locale.toString(),
              ).format(now),
              textAlign: TextAlign.center,
              style: TextStyles.font24greyColor900Weight600,
            ),
            verticalSpace(4),
            Text(
              intl.DateFormat(
                'EEEE, MMMM d',
                context.locale.toString(),
              ).format(now),
              textAlign: TextAlign.center,
              style: TextStyles.font14greyColorA3W400,
            ),
            verticalSpace(16),
            const _ClockBranchInfoWidget(),
            verticalSpace(12),
            _BranchRangeWidget(color: actionColor),
            verticalSpace(12),
            _ClockActionButtonWidget(
              title: context.tr(actionKey),
              color: actionColor,
              onTap: () {
                Navigator.pop(context);
                ProfileClockSuccessDialogWidget.show(
                  context,
                  isClockIn: !isClockedIn,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ClockDialogHeaderWidget extends StatelessWidget {
  final String title;

  const _ClockDialogHeaderWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: TextStyles.font16greyColor900Weight600),
        ),
        InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(4.r),
          child: Icon(Icons.close, size: 18.r, color: AppColors.greyColor600),
        ),
      ],
    );
  }
}

class _ClockBranchInfoWidget extends StatelessWidget {
  const _ClockBranchInfoWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.8.r),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColorFA, width: .8.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16.r,
                color: AppColors.greenColor500,
              ),
              horizontalSpace(8),
              Expanded(
                child: Text(
                  context.tr('branchContact.branchName'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font14greyColor900Weight500,
                ),
              ),
            ],
          ),
          verticalSpace(8),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 24.w),
            child: Text(
              context.tr('profile.branchAddress'),
              style: TextStyles.font12greyColorA3W400,
            ),
          ),
          verticalSpace(8),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 24.w),
            child: Row(
              children: [
                Icon(
                  Icons.schedule_outlined,
                  size: 12.r,
                  color: AppColors.greyColorA3,
                ),
                horizontalSpace(8),
                Text(
                  context.tr('profile.branchWorkingHours'),
                  style: TextStyles.font12greyColorA3W400,
                ),
              ],
            ),
          ),
          verticalSpace(8),
          Padding(
            padding: EdgeInsetsDirectional.only(start: 24.w),
            child: Text(
              context.tr('profile.branchCoordinates'),
              style: TextStyles.font10greyColorA3w400.copyWith(
                color: const Color(0xffD4D4D4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BranchRangeWidget extends StatelessWidget {
  final Color color;

  const _BranchRangeWidget({required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.r,
          height: 10.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        horizontalSpace(8),
        Text(
          context.tr('profile.withinBranchRange'),
          style: TextStyles.font14greenColor500W500.copyWith(color: color),
        ),
      ],
    );
  }
}

class _ClockActionButtonWidget extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ClockActionButtonWidget({
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyColor900.withValues(alpha: .06),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(title, style: TextStyles.font16whiteColorWeight600),
      ),
    );
  }
}
