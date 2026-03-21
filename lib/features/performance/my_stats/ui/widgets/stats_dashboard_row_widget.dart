import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/assets_manager.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatsDashboardRowWidget extends StatelessWidget {
  final String title1;
  final String title2;
  final String value1;
  final String value2;
  final String change1;
  final String change2;
  final bool isUp1;
  final bool isUp2;
  const StatsDashboardRowWidget({
    super.key,
    required this.title1,
    required this.title2,
    required this.value1,
    required this.value2,
    required this.change1,
    required this.change2,
    required this.isUp1,
    required this.isUp2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: AppColors.greyColor1001.withValues(alpha: .2),
                width: .8,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyColor900.withValues(alpha: .04),
                  blurRadius: 2,
                  spreadRadius: 0,
                  offset: const Offset(0, 1),
                ),
                BoxShadow(
                  color: AppColors.greyColor900.withValues(alpha: .05),
                  blurRadius: 3,
                  spreadRadius: 0,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title1, style: TextStyles.font10greyColorA3W500),

                verticalSpace(8),
                Text(value1, style: TextStyles.font20greyColor900W600),
                verticalSpace(4),

                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: isUp1
                            ? AppColors.greenColor500.withValues(alpha: .1)
                            : AppColors.errorColor100.withValues(alpha: .1),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            isUp1
                                ? ImageAsset.uppRowIcon
                                : ImageAsset.downRowIcon,
                          ),
                          horizontalSpace(2),
                          Text(
                            '${isUp1 ? '+' : '-'}$change1%',
                            style: isUp1
                                ? TextStyles.font12greenColor500W600
                                : TextStyles.font10errorColor100W600,
                          ),
                        ],
                      ),
                    ),
                    horizontalSpace(4),
                    Text('vs last', style: TextStyles.font12greyColorA3W400),
                  ],
                ),
              ],
            ),
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: AppColors.greyColor1001.withValues(alpha: .2),
                width: .8,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greyColor900.withValues(alpha: .04),
                  blurRadius: 2,
                  spreadRadius: 0,
                  offset: const Offset(0, 1),
                ),
                BoxShadow(
                  color: AppColors.greyColor900.withValues(alpha: .05),
                  blurRadius: 3,
                  spreadRadius: 0,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(title2, style: TextStyles.font10greyColorA3W500),

                verticalSpace(8),
                Text(value2, style: TextStyles.font20greyColor900W600),
                verticalSpace(4),

                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: isUp2
                            ? AppColors.greenColor500.withValues(alpha: .1)
                            : AppColors.errorColor100.withValues(alpha: .1),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            isUp2
                                ? ImageAsset.uppRowIcon
                                : ImageAsset.downRowIcon,
                          ),
                          horizontalSpace(2),
                          Text(
                            '${isUp2 ? '+' : '-'}$change2%',
                            style: isUp2
                                ? TextStyles.font12greenColor500W600
                                : TextStyles.font10errorColor100W600,
                          ),
                        ],
                      ),
                    ),
                    horizontalSpace(4),
                    Text('vs last', style: TextStyles.font12greyColorA3W400),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
