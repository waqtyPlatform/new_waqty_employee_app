import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class EstimatedPayCardWidget extends StatelessWidget {
  const EstimatedPayCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.greenColor500,
            AppColors.greenColor500,
            Color(0xff007341),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.greenColor500.withValues(alpha: .22),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.greenColor500.withValues(alpha: .1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            top: -26.h,
            start: -26.w,
            child: _DecorativeCircle(size: 144.r, opacity: .04),
          ),
          PositionedDirectional(
            top: -8.h,
            start: -8.w,
            child: _DecorativeCircle(size: 80.r, opacity: .03),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('myEarning.estimatedNetPay'),
                style: TextStyles.font12whiteColorWeight600.copyWith(
                  color: AppColors.whiteColor.withValues(alpha: .65),
                  fontWeight: FontWeight.w500,
                ),
              ),
              verticalSpace(8),
              Text(
                'EGP 5,350',
                style: TextStyles.font32greyColor900Weight600.copyWith(
                  color: AppColors.whiteColor,
                  fontSize: 40.sp,
                  height: 1.2,
                ),
              ),
              verticalSpace(8),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 9.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      context.tr('myEarning.pending'),
                      style: TextStyles.font10greyColorA3W600.copyWith(
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                  horizontalSpace(8),
                  Expanded(
                    child: Text(
                      context.tr('myEarning.closesDate'),
                      style: TextStyles.font12whiteColorWeight600.copyWith(
                        color: AppColors.whiteColor.withValues(alpha: .55),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.tr('myEarning.fullBreakdown'),
                    style: TextStyles.font12whiteColorWeight600.copyWith(
                      color: AppColors.whiteColor.withValues(alpha: .75),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  horizontalSpace(4),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.whiteColor.withValues(alpha: .75),
                    size: 16.r,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _DecorativeCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}
