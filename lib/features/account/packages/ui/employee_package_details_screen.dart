import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/packages/data/models/employee_package_model.dart';
import 'package:new_waqty_employee_app/features/account/packages/logic/employee_packages_cubit.dart';
import 'package:new_waqty_employee_app/features/account/packages/logic/employee_packages_state.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_header_widget.dart';

class EmployeePackageDetailsScreen extends StatefulWidget {
  final String uuid;

  const EmployeePackageDetailsScreen({super.key, required this.uuid});

  @override
  State<EmployeePackageDetailsScreen> createState() =>
      _EmployeePackageDetailsScreenState();
}

class _EmployeePackageDetailsScreenState
    extends State<EmployeePackageDetailsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      EmployeePackagesCubit.get(context).getPackageDetails(widget.uuid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            const AccountSupportHeaderWidget(
              titleKey: 'employeePackages.detailsTitle',
            ),
            Expanded(
              child: BlocBuilder<EmployeePackagesCubit, EmployeePackagesState>(
                buildWhen: (previous, current) =>
                    current is EmployeePackageDetailsLoadingState ||
                    current is EmployeePackageDetailsSuccessState ||
                    current is EmployeePackageDetailsErrorState,
                builder: (context, state) {
                  final cubit = EmployeePackagesCubit.get(context);
                  if (state is EmployeePackageDetailsLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.greenColor500,
                      ),
                    );
                  }
                  if (state is EmployeePackageDetailsErrorState ||
                      cubit.packageDetails == null) {
                    final message = state is EmployeePackageDetailsErrorState
                        ? state.message
                        : '';
                    return _DetailsErrorWidget(
                      uuid: widget.uuid,
                      message: message,
                    );
                  }
                  return _PackageDetailsContent(package: cubit.packageDetails!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PackageDetailsContent extends StatelessWidget {
  final EmployeePackageModel package;

  const _PackageDetailsContent({required this.package});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.greenColor500,
      onRefresh: () =>
          EmployeePackagesCubit.get(context).getPackageDetails(package.uuid),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        children: [
          AccountSupportCardWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        package.name ?? context.tr('employeePackages.unnamed'),
                        style: TextStyles.font18greyColor900Weight600,
                      ),
                    ),
                    horizontalSpace(8),
                    _Chip(
                      label: package.statusLabel.isEmpty
                          ? package.status
                          : package.statusLabel,
                      color: _statusColor(package.status),
                    ),
                  ],
                ),
                if (package.description?.isNotEmpty == true) ...[
                  verticalSpace(8),
                  Text(
                    package.description!,
                    style: TextStyles.font12greyColor500W400.copyWith(
                      height: 1.45,
                    ),
                  ),
                ],
                verticalSpace(14),
                _PriceRow(package: package),
              ],
            ),
          ),
          verticalSpace(10),
          _InfoCard(package: package),
          if (package.currentOffer != null) ...[
            verticalSpace(10),
            _OfferCard(package: package),
          ],
          verticalSpace(10),
          _ServicesCard(items: package.items, currency: package.currency),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final EmployeePackageModel package;

  const _PriceRow({required this.package});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${package.effectivePrice} ${package.currency}',
          style: TextStyles.font18greyColor900Weight600.copyWith(
            color: AppColors.greenColor500,
          ),
        ),
        if (package.hasOffer &&
            package.packagePrice != package.effectivePrice) ...[
          horizontalSpace(10),
          Text(
            '${package.packagePrice} ${package.currency}',
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

class _InfoCard extends StatelessWidget {
  final EmployeePackageModel package;

  const _InfoCard({required this.package});

  @override
  Widget build(BuildContext context) {
    return AccountSupportCardWidget(
      child: Column(
        children: [
          _InfoRow(
            label: context.tr('employeePackages.branch'),
            value: package.branch.name,
          ),
          _InfoRow(
            label: context.tr('employeePackages.type'),
            value: package.packageTypeLabel,
          ),
          if (package.hasSessionMode)
            _InfoRow(
              label: context.tr('employeePackages.sessionMode'),
              value: package.sessionModeLabel!,
            ),
          _InfoRow(
            label: context.tr('employeePackages.availability'),
            value: package.availabilityLabel,
          ),
          _InfoRow(
            label: context.tr('employeePackages.duration'),
            value: _duration(context, package.totalDurationMinutes),
          ),
          if (package.packageType == 'usage_based')
            _InfoRow(
              label: context.tr('employeePackages.units'),
              value: context.tr(
                'employeePackages.unitsCount',
                namedArgs: {
                  'count': '${package.initialUnits ?? 0}',
                  'unit': package.unitName ?? '',
                },
              ),
            )
          else
            _InfoRow(
              label: context.tr('employeePackages.sessions'),
              value: context.tr(
                'employeePackages.sessionsCount',
                namedArgs: {'count': '${package.sessionsIncluded}'},
              ),
            ),
          if (package.validityDays != null)
            _InfoRow(
              label: context.tr('employeePackages.validity'),
              value: context.tr(
                'employeePackages.validityDays',
                namedArgs: {'count': '${package.validityDays}'},
              ),
            ),
          if (package.startsAt != null)
            _InfoRow(
              label: context.tr('employeePackages.startsAt'),
              value: _dateTime(context, package.startsAt!),
            ),
          if (package.endsAt != null)
            _InfoRow(
              label: context.tr('employeePackages.endsAt'),
              value: _dateTime(context, package.endsAt!),
              showDivider: false,
            ),
        ],
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final EmployeePackageModel package;

  const _OfferCard({required this.package});

  @override
  Widget build(BuildContext context) {
    final offer = package.currentOffer!;
    return AccountSupportCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('employeePackages.currentOffer'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(10),
          _InfoRow(
            label: context.tr('employeePackages.offerPrice'),
            value: '${offer.offerPrice} ${package.currency}',
          ),
          _InfoRow(
            label: context.tr('employeePackages.startsAt'),
            value: _dateTime(context, offer.startsAt),
          ),
          _InfoRow(
            label: context.tr('employeePackages.endsAt'),
            value: _dateTime(context, offer.endsAt),
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _ServicesCard extends StatelessWidget {
  final List<EmployeePackageItemModel> items;
  final String currency;

  const _ServicesCard({required this.items, required this.currency});

  @override
  Widget build(BuildContext context) {
    return AccountSupportCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('employeePackages.services'),
            style: TextStyles.font14greyColor900Weight600,
          ),
          verticalSpace(10),
          if (items.isEmpty)
            Text(
              context.tr('employeePackages.noServices'),
              style: TextStyles.font12greyColor500W400,
            )
          else
            ...items.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: _ServiceItem(item: item, currency: currency),
              ),
            ),
        ],
      ),
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final EmployeePackageItemModel item;
  final String currency;

  const _ServiceItem({required this.item, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.greyColorFA,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name ?? context.tr('employeePackages.serviceUnavailable'),
            style: TextStyles.font12greyColor900Weight600,
          ),
          verticalSpace(6),
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: [
              _Chip(
                label: _duration(context, item.durationMinutes),
                color: AppColors.greyColor500,
              ),
              _Chip(
                label:
                    '${context.tr('employeePackages.price')}: ${item.packageItemPrice} $currency',
                color: AppColors.greenColor500,
              ),
              if (item.discountAmount != '0.00')
                _Chip(
                  label:
                      '${context.tr('employeePackages.discount')}: ${item.discountAmount} $currency',
                  color: AppColors.warningColor1001,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool showDivider;

  const _InfoRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(label, style: TextStyles.font12greyColor500W400),
            ),
            horizontalSpace(10),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyles.font12greyColor900Weight600,
              ),
            ),
          ],
        ),
        if (showDivider) ...[
          verticalSpace(10),
          Divider(height: 1.h, color: AppColors.greyColor50),
          verticalSpace(10),
        ],
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(
        label,
        style: TextStyles.font10greyColor3003Weight500.copyWith(color: color),
      ),
    );
  }
}

class _DetailsErrorWidget extends StatelessWidget {
  final String uuid;
  final String message;

  const _DetailsErrorWidget({required this.uuid, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.isEmpty
                  ? context.tr('employeePackages.detailsLoadFailed')
                  : message,
              textAlign: TextAlign.center,
              style: TextStyles.font14greyColor500W500,
            ),
            verticalSpace(10),
            TextButton(
              onPressed: () =>
                  EmployeePackagesCubit.get(context).getPackageDetails(uuid),
              child: Text(
                context.tr('common.retry'),
                style: TextStyles.font14greenColor500Weight600,
              ),
            ),
          ],
        ),
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

String _dateTime(BuildContext context, String value) {
  final parsed = AppDateFormat.parseBackendDateTime(value);
  if (parsed == null) return value;
  return AppDateFormat.dayMonthTime(context, parsed);
}
