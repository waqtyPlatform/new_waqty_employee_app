import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_details_response_model.dart';

class BookingItemSourceSection extends StatelessWidget {
  final BookingServiceLine service;
  final bool showDetails;

  const BookingItemSourceSection({
    super.key,
    required this.service,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    final lines = showDetails ? _lines(context) : const <String>[];
    final badge = _badge(context);
    if (badge == null && lines.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (badge != null) ...[
          _SourceBadge(label: badge),
          if (lines.isNotEmpty) verticalSpace(6),
        ],
        ...lines.map(
          (line) => Padding(
            padding: EdgeInsets.only(bottom: 3.h),
            child: Text(
              line,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.font12greyColorA3W400,
            ),
          ),
        ),
      ],
    );
  }

  String? _badge(BuildContext context) {
    if (service.sourceType == 'normal_service') {
      return context.tr('bookingDetails.normalServiceBadge');
    }
    if (service.isSingleVisitPackage) {
      return context.tr('bookingDetails.packageBadge');
    }
    if (service.isMultiSession) {
      return context.tr('bookingDetails.packageSessionBadge');
    }
    if (service.isUsageBased) {
      return context.tr('bookingDetails.usageBalanceBadge');
    }
    if (service.isFollowUp) {
      return context.tr('bookingDetails.followUpBadge');
    }
    return null;
  }

  List<String> _lines(BuildContext context) {
    if (service.isSingleVisitPackage) return _singleVisitPackageLines(context);
    if (service.isMultiSession) return _multiSessionLines(context);
    if (service.isUsageBased) return _usageLines(context);
    if (service.isFollowUp) return _followUpLines(context);
    return const [];
  }

  List<String> _singleVisitPackageLines(BuildContext context) {
    final package = service.package;
    return [
      if (package?.name?.isNotEmpty == true) package!.name!,
      if (service.coveredByPackage)
        context.tr('bookingDetails.coveredByPackage'),
      if (_hasOfferPrice(package)) _offerPriceLine(package!),
    ].where((line) => line.isNotEmpty).toList();
  }

  List<String> _multiSessionLines(BuildContext context) {
    final package = service.package;
    final sessions = package?.sessions;
    return [
      if (package?.name?.isNotEmpty == true) package!.name!,
      if (package?.sessionNumber != null && sessions != null)
        context.tr(
          'bookingDetails.sessionOf',
          namedArgs: {
            'current': package!.sessionNumber.toString(),
            'total': sessions.total.toString(),
          },
        ),
      if (sessions != null)
        context.tr(
          'bookingDetails.remainingSessions',
          namedArgs: {'count': sessions.remaining.toString()},
        ),
      if (package?.expiresAt?.isNotEmpty == true)
        context.tr(
          'bookingDetails.validUntil',
          namedArgs: {'date': _formatDateOnly(context, package!.expiresAt!)},
        ),
      if (service.coveredByPackage && service.newCharge == '0')
        context.tr('bookingDetails.coveredByPackage'),
    ];
  }

  List<String> _usageLines(BuildContext context) {
    final usage = service.usagePackage;
    final selectedService = usage?.selectedService?.name;
    final units = usage?.availableUnits;
    final unitName = usage?.unitName ?? '';
    return [
      if (usage?.name?.isNotEmpty == true) usage!.name!,
      if (selectedService?.isNotEmpty == true)
        '${context.tr('bookingDetails.selectedService')}: $selectedService',
      if (units != null)
        context.tr(
          'bookingDetails.availableBalance',
          namedArgs: {'count': units.toString(), 'unit': unitName},
        ),
      if (service.coveredByUsagePackage || service.coveredByPackage)
        context.tr('bookingDetails.coveredByPackage'),
      if (service.usageUnitsConsumed != null)
        context.tr(
          'bookingDetails.unitsConsumed',
          namedArgs: {
            'count': service.usageUnitsConsumed.toString(),
            'unit': unitName,
          },
        ),
    ];
  }

  List<String> _followUpLines(BuildContext context) {
    final followUp = service.followUp;
    return [
      if (followUp?.originalService?.isNotEmpty == true)
        '${context.tr('bookingDetails.originalService')}: ${followUp!.originalService!}',
      if (followUp?.originalEmployee?.isNotEmpty == true)
        '${context.tr('bookingDetails.originalEmployee')}: ${followUp!.originalEmployee!}',
      if (followUp?.remainingUses != null)
        context.tr(
          'bookingDetails.remainingUses',
          namedArgs: {'count': followUp!.remainingUses.toString()},
        ),
      if (followUp?.validUntil?.isNotEmpty == true)
        context.tr(
          'bookingDetails.validUntil',
          namedArgs: {'date': _formatDateOnly(context, followUp!.validUntil!)},
        ),
      if (followUp?.afterExpiryPolicy == 'allow')
        context.tr('bookingDetails.expiredRecommendedPeriod'),
    ];
  }

  bool _hasOfferPrice(PackageMeta? package) {
    return package?.basePrice?.isNotEmpty == true &&
        package?.offerPrice?.isNotEmpty == true &&
        package?.effectivePrice?.isNotEmpty == true &&
        package!.basePrice != package.effectivePrice;
  }

  String _offerPriceLine(PackageMeta package) {
    return '${package.basePrice} → ${package.effectivePrice}';
  }

  String _formatDateOnly(BuildContext context, String value) {
    final date = AppDateFormat.parseBackendDateTime(value);
    if (date == null) return value;
    return AppDateFormat.fullDate(context, date);
  }
}

class _SourceBadge extends StatelessWidget {
  final String label;

  const _SourceBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.greenColor5005,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyles.font10greyColorA3W600.copyWith(
          color: AppColors.greenColor500,
        ),
      ),
    );
  }
}
