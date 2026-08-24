import 'package:easy_localization/easy_localization.dart';
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
  final bool? isUp1;
  final bool? isUp2;
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
          child: _StatsDashboardCard(
            title: title1,
            value: value1,
            change: change1,
            isUp: isUp1,
          ),
        ),
        horizontalSpace(8),
        Expanded(
          child: _StatsDashboardCard(
            title: title2,
            value: value2,
            change: change2,
            isUp: isUp2,
          ),
        ),
      ],
    );
  }
}

class _StatsDashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool? isUp;

  const _StatsDashboardCard({
    required this.title,
    required this.value,
    required this.change,
    required this.isUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 92.h),
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
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font10greyColorA3W500,
          ),
          verticalSpace(7),
          SizedBox(
            width: double.infinity,
            height: 28.h,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Text(value, style: TextStyles.font20greyColor900W600),
            ),
          ),
          verticalSpace(4),
          Row(
            children: [
              Flexible(
                child: _KpiChangePill(change: change, isUp: isUp),
              ),
              horizontalSpace(4),
              Expanded(
                child: Text(
                  context.tr('myStats.vsLast'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font12greyColorA3W400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KpiChangePill extends StatelessWidget {
  final String change;
  final bool? isUp;

  const _KpiChangePill({required this.change, required this.isUp});

  @override
  Widget build(BuildContext context) {
    if (isUp == null || change.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.greyColorFA,
          borderRadius: BorderRadius.circular(50.r),
        ),
        child: Text(
          context.tr('myStats.noComparisonShort'),
          style: TextStyles.font10greyColorA3W600,
        ),
      );
    }

    final isPositive = isUp == true;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: isPositive
            ? AppColors.greenColor500.withValues(alpha: .1)
            : AppColors.errorColor100.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 6.r,
            height: 6.r,
            child: SvgPicture.asset(
              isPositive ? ImageAsset.uppRowIcon : ImageAsset.downRowIcon,
            ),
          ),
          horizontalSpace(2),
          Flexible(
            child: Text(
              '${isPositive ? '+' : '-'}$change%',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: isPositive
                  ? TextStyles.font12greenColor500W600
                  : TextStyles.font10errorColor100W600,
            ),
          ),
        ],
      ),
    );
  }
}
