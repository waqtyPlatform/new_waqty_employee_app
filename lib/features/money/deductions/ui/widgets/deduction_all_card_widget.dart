import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/money/shared/widgets/my_earning_card_decoration.dart';

class DeductionAllCardWidget extends StatelessWidget {
  const DeductionAllCardWidget({super.key});

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
            context.tr('myEarning.allDeductions'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(12),
          _DeductionEntryRowWidget(
            titleKey: 'lateArrivalInstances',
            dateKey: 'lateArrivalDates',
            amount: '- EGP 150',
            icon: Icons.error_outline,
            descriptionKey: 'lateArrivalDescription',
            isExpanded: true,
          ),
          _DeductionEntryRowWidget(
            titleKey: 'materialUsageOverage',
            dateKey: 'mar8',
            amount: '- EGP 50',
            icon: Icons.water_drop_outlined,
            showDivider: false,
          ),
          Divider(color: AppColors.greyColor1001.withValues(alpha: .35)),
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr('myEarning.total'),
                  style: TextStyles.font14greyColor900Weight600,
                ),
              ),
              Text('- EGP 200', style: TextStyles.font14errorColor2002W500),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeductionEntryRowWidget extends StatelessWidget {
  final String titleKey;
  final String dateKey;
  final String amount;
  final IconData icon;
  final String? descriptionKey;
  final bool isExpanded;
  final bool showDivider;

  const _DeductionEntryRowWidget({
    required this.titleKey,
    required this.dateKey,
    required this.amount,
    required this.icon,
    this.descriptionKey,
    this.isExpanded = false,
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
                  color: AppColors.greyColor1001.withValues(alpha: .12),
                  width: .8.w,
                ),
              )
            : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 36.r,
                height: 36.r,
                decoration: const BoxDecoration(
                  color: AppColors.errorColor2003,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.errorColor2002, size: 16.r),
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
                      context.tr('myEarning.$dateKey'),
                      style: TextStyles.font12greyColorA3W400,
                    ),
                  ],
                ),
              ),
              horizontalSpace(8),
              Text(amount, style: TextStyles.font14errorColor2002W500),
              horizontalSpace(6),
              Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: AppColors.greyColor100,
                size: 18.r,
              ),
            ],
          ),
          if (descriptionKey != null) ...[
            verticalSpace(10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.errorColor2003,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                context.tr('myEarning.$descriptionKey'),
                style: TextStyles.font12greyColorA3W400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
