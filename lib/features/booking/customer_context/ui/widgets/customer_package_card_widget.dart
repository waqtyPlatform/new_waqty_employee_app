import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/data/models/customer_context_model.dart';

class CustomerPackageCardWidget extends StatelessWidget {
  final CustomerPackagePurchaseModel package;

  const CustomerPackageCardWidget({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.greyColorFA,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColorF5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  package.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font14greyColor900Weight600,
                ),
              ),
              _PaymentBadge(status: package.paymentStatus),
            ],
          ),
          verticalSpace(8),
          _InfoLine(
            label: context.tr('bookingDetails.added'),
            value: package.status,
          ),
          if (package.purchasedAt.isNotEmpty)
            _InfoLine(
              label: context.tr('customerContext.purchasedAt'),
              value: package.purchasedAt,
            ),
          if (package.expiresAt.isNotEmpty)
            _InfoLine(
              label: context.tr('customerContext.expiresAt'),
              value: package.expiresAt,
            ),
          if (package.sessions != null) ...[
            Divider(color: AppColors.greyColorE5),
            _InfoLine(
              label: context.tr('customerContext.sessionsCount'),
              value: package.sessions!.total.toString(),
            ),
            _InfoLine(
              label: context.tr('customerContext.sessionsUsed'),
              value: package.sessions!.used.toString(),
            ),
            _InfoLine(
              label: context.tr('customerContext.sessionsReserved'),
              value: package.sessions!.reserved.toString(),
            ),
            _InfoLine(
              label: context.tr('customerContext.sessionsRemaining'),
              value: package.sessions!.remaining.toString(),
            ),
          ],
          if (package.usage != null) ...[
            Divider(color: AppColors.greyColorE5),
            _InfoLine(
              label: context.tr('customerContext.availableBalance'),
              value:
                  '${package.usage!.available ?? '-'} ${package.usage!.unitName ?? ''}',
            ),
            if (package.usage!.totalPurchased != null)
              _InfoLine(
                label: context.tr('customerContext.totalUnits'),
                value: package.usage!.totalPurchased.toString(),
              ),
            if (package.usage!.totalConsumed != null)
              _InfoLine(
                label: context.tr('customerContext.usedUnits'),
                value: package.usage!.totalConsumed.toString(),
              ),
          ],
          if (package.services.isNotEmpty) ...[
            verticalSpace(6),
            Text(
              '${context.tr('customerContext.validFor')}: ${package.services.map((item) => item.name).join(', ')}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.font12greyColorA3W400,
            ),
          ],
          Divider(color: AppColors.greyColorE5),
          _InfoLine(
            label: context.tr('customerContext.paidAmount'),
            value: '${package.currency} ${package.paidAmount}',
          ),
          _InfoLine(
            label: context.tr('customerContext.remainingAmount'),
            value: '${package.currency} ${package.remainingAmount}',
          ),
        ],
      ),
    );
  }
}

class _PaymentBadge extends StatelessWidget {
  final String status;

  const _PaymentBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        _label(context),
        style: TextStyles.font10greyColorA3W600.copyWith(color: _color),
      ),
    );
  }

  Color get _color {
    switch (status) {
      case 'paid':
        return AppColors.greenColor500;
      case 'partial':
      case 'partially_paid':
        return AppColors.warningColor1001;
      default:
        return AppColors.errorColor2002;
    }
  }

  String _label(BuildContext context) {
    switch (status) {
      case 'paid':
        return context.tr('customerContext.paid');
      case 'partial':
      case 'partially_paid':
        return context.tr('customerContext.partial');
      default:
        return context.tr('customerContext.unpaid');
    }
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.h),
      child: Row(
        children: [
          Text(label, style: TextStyles.font12greyColorA3W400),
          const Spacer(),
          Flexible(
            child: Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.font12greyColor900Weight500,
            ),
          ),
        ],
      ),
    );
  }
}
