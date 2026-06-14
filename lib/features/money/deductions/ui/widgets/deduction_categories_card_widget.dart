import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class DeductionCategoriesCardWidget extends StatelessWidget {
  const DeductionCategoriesCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: myEarningCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('myEarning.byCategory'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(12),
          _DeductionCategoryRowWidget(
            titleKey: 'deductionAttendance',
            subtitleKey: 'deductionAttendanceSubtitle',
            amount: '- EGP 150',
            icon: Icons.error_outline,
            iconColor: AppColors.errorColor2002,
            iconBackgroundColor: AppColors.errorColor2003,
          ),
          _DeductionCategoryRowWidget(
            titleKey: 'deductionMaterials',
            subtitleKey: 'deductionMaterialsSubtitle',
            amount: '- EGP 50',
            icon: Icons.water_drop_outlined,
            iconColor: AppColors.warningColor1001,
            iconBackgroundColor: AppColors.warningColor1002,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _DeductionCategoryRowWidget extends StatelessWidget {
  final String titleKey;
  final String subtitleKey;
  final String amount;
  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final bool showDivider;

  const _DeductionCategoryRowWidget({
    required this.titleKey,
    required this.subtitleKey,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: showDivider ? 12.h : 0),
      margin: EdgeInsets.only(bottom: showDivider ? 12.h : 0),
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                bottom: BorderSide(
                  color: AppColors.greyColor1001.withValues(alpha: .15),
                  width: .8.w,
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 15.r),
          ),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('myEarning.$titleKey'),
                  style: TextStyles.font14greyColor900Weight500,
                ),
                verticalSpace(3),
                Text(
                  context.tr('myEarning.$subtitleKey'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font12greyColorA3W400,
                ),
              ],
            ),
          ),
          horizontalSpace(12),
          Text(amount, style: TextStyles.font14errorColor2002W500),
        ],
      ),
    );
  }
}
