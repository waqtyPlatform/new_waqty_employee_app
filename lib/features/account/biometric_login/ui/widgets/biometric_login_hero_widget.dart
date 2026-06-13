import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/biometric_login/ui/widgets/biometric_login_view_data.dart';

class BiometricLoginHeroWidget extends StatelessWidget {
  final BiometricLoginHeroData data;
  final double topPadding;
  final double iconFrameSize;

  const BiometricLoginHeroWidget({
    super.key,
    required this.data,
    this.topPadding = 24,
    this.iconFrameSize = 140,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding.h),
      child: Column(
        children: [
          SizedBox(
            width: iconFrameSize.w,
            height: iconFrameSize.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (data.showPulse) ...[
                  _PulseCircle(size: iconFrameSize, opacity: .12),
                  _PulseCircle(size: iconFrameSize * .72, opacity: .2),
                ],
                Container(
                  width: 88.r,
                  height: 88.r,
                  decoration: BoxDecoration(
                    color: data.backgroundColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: data.borderColor, width: .8.w),
                  ),
                  child: Icon(data.icon, size: 45.r, color: data.iconColor),
                ),
                if (data.showCheckBadge)
                  PositionedDirectional(
                    end: 22.w,
                    bottom: 23.h,
                    child: Container(
                      width: 24.r,
                      height: 24.r,
                      decoration: const BoxDecoration(
                        color: AppColors.greenColor500,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 14.r,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          verticalSpace(12),
          Text(
            context.tr(data.titleKey),
            textAlign: TextAlign.center,
            style: TextStyles.font18greyColor900Weight600,
          ),
          verticalSpace(6),
          Text(
            context.tr(data.subtitleKey),
            textAlign: TextAlign.center,
            style: TextStyles.font14greyColorA3W400,
          ),
          if (data.showDots) ...[verticalSpace(8), const _ProgressDotsWidget()],
        ],
      ),
    );
  }
}

class _PulseCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _PulseCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.greenColor500.withValues(alpha: opacity),
          width: .8.w,
        ),
      ),
    );
  }
}

class _ProgressDotsWidget extends StatelessWidget {
  const _ProgressDotsWidget();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(.95),
        horizontalSpace(4),
        _dot(.55),
        horizontalSpace(4),
        _dot(.22),
      ],
    );
  }

  Widget _dot(double opacity) {
    return Container(
      width: 5.r,
      height: 5.r,
      decoration: BoxDecoration(
        color: AppColors.greenColor500.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}
