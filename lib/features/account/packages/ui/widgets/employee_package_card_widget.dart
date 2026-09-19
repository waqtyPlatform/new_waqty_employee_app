import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/packages/data/models/employee_package_model.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';

class EmployeePackageCardWidget extends StatelessWidget {
  final EmployeePackageModel package;
  final VoidCallback onTap;

  const EmployeePackageCardWidget({
    super.key,
    required this.package,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: AccountSupportCardWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    package.name ?? context.tr('employeePackages.unnamed'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font14greyColor900Weight600,
                  ),
                ),
                horizontalSpace(8),
                _StatusChip(package: package),
              ],
            ),
            if (package.description?.isNotEmpty == true) ...[
              verticalSpace(6),
              Text(
                package.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.font12greyColor500W400.copyWith(height: 1.4),
              ),
            ],
            verticalSpace(10),
            Row(
              children: [
                Expanded(
                  child: _PriceBlock(
                    currency: package.currency,
                    price: package.effectivePrice,
                    originalPrice: package.hasOffer
                        ? package.packagePrice
                        : null,
                  ),
                ),
                horizontalSpace(8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.greyColor300,
                  size: 14.r,
                ),
              ],
            ),
            verticalSpace(10),
            Wrap(
              spacing: 6.w,
              runSpacing: 6.h,
              children: [
                _MetaChip(label: package.packageTypeLabel),
                if (package.hasSessionMode)
                  _MetaChip(
                    label: package.sessionModeLabel!,
                    color: AppColors.blueColor506,
                  ),
                _MetaChip(
                  label: _duration(context, package.totalDurationMinutes),
                ),
                if (package.packageType == 'usage_based')
                  _MetaChip(
                    label: context.tr(
                      'employeePackages.unitsCount',
                      namedArgs: {
                        'count': '${package.initialUnits ?? 0}',
                        'unit': package.unitName ?? '',
                      },
                    ),
                  )
                else
                  _MetaChip(
                    label: context.tr(
                      'employeePackages.sessionsCount',
                      namedArgs: {'count': '${package.sessionsIncluded}'},
                    ),
                  ),
                if (package.hasOffer)
                  _MetaChip(
                    label: context.tr('employeePackages.currentOffer'),
                    color: AppColors.warningColor1001,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final EmployeePackageModel package;

  const _StatusChip({required this.package});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(package.status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        package.statusLabel.isEmpty ? package.status : package.statusLabel,
        style: TextStyles.font12greyColor900Weight600.copyWith(color: color),
      ),
    );
  }
}

class _PriceBlock extends StatelessWidget {
  final String currency;
  final String price;
  final String? originalPrice;

  const _PriceBlock({
    required this.currency,
    required this.price,
    this.originalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$price $currency',
          style: TextStyles.font16greyColor900Weight600.copyWith(
            color: AppColors.greenColor500,
          ),
        ),
        if (originalPrice != null && originalPrice != price) ...[
          horizontalSpace(8),
          Text(
            '$originalPrice $currency',
            style: TextStyles.font12greyColor500W400.copyWith(
              decoration: TextDecoration.lineThrough,
              color: AppColors.greyColor400,
            ),
          ),
        ],
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final Color color;

  const _MetaChip({required this.label, this.color = AppColors.greyColor500});

  @override
  Widget build(BuildContext context) {
    if (label.trim().isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.greyColorFA,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        label,
        style: TextStyles.font10greyColor3003Weight500.copyWith(color: color),
      ),
    );
  }
}

Color _statusColor(String status) {
  return switch (status) {
    'active' => AppColors.greenColor500,
    'draft' => AppColors.warningColor1001,
    'inactive' => AppColors.greyColor500,
    'expired' => AppColors.errorColor2002,
    _ => AppColors.greyColor500,
  };
}

String _duration(BuildContext context, int minutes) {
  if (minutes <= 0) return context.tr('employeePackages.durationUnavailable');
  return context.tr(
    'employeePackages.minutes',
    namedArgs: {'count': '$minutes'},
  );
}
