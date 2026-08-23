import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_addable_items_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/services_with_prices_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_cubit.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_state.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/ui/widgets/customer_context_bottom_sheet.dart';

void showAddServiceBottomSheet(
  BuildContext context,
  BookingDetailsCubit cubit,
  String currency,
  String? visitUuid,
  String? customerUuid,
) {
  if (visitUuid?.isNotEmpty == true) {
    cubit.getAddableItems(visitUuid: visitUuid!, refresh: true);
  } else {
    cubit.getServicesWithPrices(refresh: true);
  }
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: AppColors.greyColor3004.withValues(alpha: .4),
    builder: (_) {
      return BlocProvider.value(
        value: cubit,
        child: BookingAddServiceBottomSheet(
          currency: currency,
          visitUuid: visitUuid,
          customerUuid: customerUuid,
        ),
      );
    },
  );
}

enum _BookingAddItemTab { services, packages, customerPackages, subscriptions }

class BookingAddServiceBottomSheet extends StatefulWidget {
  final String currency;
  final String? visitUuid;
  final String? customerUuid;

  const BookingAddServiceBottomSheet({
    super.key,
    required this.currency,
    required this.visitUuid,
    required this.customerUuid,
  });

  @override
  State<BookingAddServiceBottomSheet> createState() =>
      _BookingAddServiceBottomSheetState();
}

class _BookingAddServiceBottomSheetState
    extends State<BookingAddServiceBottomSheet> {
  _BookingAddItemTab _selectedTab = _BookingAddItemTab.services;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 620.h,
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: BlocConsumer<BookingDetailsCubit, BookingDetailsState>(
        listener: (context, state) {
          if (state is OnAddBookingServiceSuccessState) {
            Navigator.pop(context);
          } else if (state is OnAddBookingServiceErrorState) {
            final message = state.message.isNotEmpty
                ? state.message
                : BookingDetailsCubit.get(context).lastErrorMessage;
            AppConstant.toast(
              message.isEmpty
                  ? context.tr('bookingDetails.addItemFailed')
                  : message,
              false,
              context,
            );
          }
        },
        buildWhen: (previous, current) {
          return current is OnServicesWithPricesLoadingState ||
              current is OnServicesWithPricesSuccessState ||
              current is OnServicesWithPricesPaginationLoadingState ||
              current is OnServicesWithPricesPaginationSuccessState ||
              current is OnAddableItemsLoadingState ||
              current is OnAddableItemsSuccessState ||
              current is OnAddableItemsErrorState ||
              current is OnAddBookingServiceLoadingState ||
              current is OnAddBookingServiceSuccessState ||
              current is OnAddBookingServiceErrorState ||
              current is OnBookingDetailsErrorState ||
              current is OnBookingDetailsCatchErrorState;
        },
        builder: (context, state) {
          final cubit = BookingDetailsCubit.get(context);

          return Column(
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.greyColorE5,
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              verticalSpace(18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.tr('bookingDetails.addBookingItem'),
                      style: TextStyles.font18greyColor900Weight600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      radius: 18.r,
                      backgroundColor: AppColors.greyColorF5,
                      child: Icon(
                        Icons.close,
                        color: AppColors.greyColor900,
                        size: 18.r,
                      ),
                    ),
                  ),
                ],
              ),
              verticalSpace(16),
              _BookingAddItemTabs(
                selectedTab: _selectedTab,
                onChanged: (tab) => setState(() => _selectedTab = tab),
              ),
              verticalSpace(16),
              Expanded(child: _buildTabContent(context, cubit)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, BookingDetailsCubit cubit) {
    switch (_selectedTab) {
      case _BookingAddItemTab.services:
        return _buildServicesContent(context, cubit);
      case _BookingAddItemTab.packages:
        return _buildPackagesContent(context, cubit);
      case _BookingAddItemTab.customerPackages:
        return _buildCustomerPackagesContent(context, cubit);
      case _BookingAddItemTab.subscriptions:
        return _buildFollowUpsContent(context, cubit);
    }
  }

  Widget _buildServicesContent(
    BuildContext context,
    BookingDetailsCubit cubit,
  ) {
    if (widget.visitUuid?.isNotEmpty == true) {
      return _buildAddableServicesContent(context, cubit);
    }

    if (cubit.isServicesWithPricesLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cubit.servicesWithPrices.isEmpty) {
      return Center(
        child: Text(
          context.tr('bookingDetails.noServicesFound'),
          style: TextStyles.font14greyColor500W500,
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels >=
            notification.metrics.maxScrollExtent - 80.h) {
          cubit.getServicesWithPrices();
        }
        return false;
      },
      child: ListView.separated(
        itemCount:
            cubit.servicesWithPrices.length +
            (cubit.isServicesWithPricesPaginationLoading ? 1 : 0),
        separatorBuilder: (_, _) =>
            Divider(height: 1.h, color: AppColors.greyColorF5),
        itemBuilder: (context, index) {
          if (index == cubit.servicesWithPrices.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          return AddServiceItemWidget(
            service: cubit.servicesWithPrices[index],
            currency: widget.currency,
            isLoading:
                cubit.addingItemKey == cubit.servicesWithPrices[index].uuid,
            onTap: () {
              cubit.addServiceToBooking(
                cubit.servicesWithPrices[index],
                visitUuid: widget.visitUuid,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAddableServicesContent(
    BuildContext context,
    BookingDetailsCubit cubit,
  ) {
    if (cubit.isAddableItemsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final services = cubit.addableItems?.services ?? [];
    if (services.isEmpty) {
      return _AddableEmptyState(
        message: context.tr('bookingDetails.noAddableServices'),
      );
    }

    return ListView.separated(
      itemCount: services.length,
      separatorBuilder: (_, _) =>
          Divider(height: 1.h, color: AppColors.greyColorF5),
      itemBuilder: (context, index) {
        final service = services[index];
        return _AddableServiceItemWidget(
          service: service,
          isLoading: cubit.addingItemKey == service.uuid,
          onTap: () {
            cubit.addServiceUuidToBooking(
              serviceUuid: service.uuid,
              visitUuid: widget.visitUuid,
              loadingKey: service.uuid,
            );
          },
        );
      },
    );
  }

  Widget _buildPackagesContent(
    BuildContext context,
    BookingDetailsCubit cubit,
  ) {
    if (cubit.isAddableItemsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final packages = cubit.addableItems?.packagesAndOffers ?? [];
    if (packages.isEmpty) {
      return _AddableEmptyState(
        message: context.tr('bookingDetails.noAddablePackages'),
      );
    }

    return ListView.separated(
      itemCount: packages.length,
      separatorBuilder: (_, _) =>
          Divider(height: 1.h, color: AppColors.greyColorF5),
      itemBuilder: (context, index) {
        final package = packages[index];
        final loadingKey = _addableLoadingKey(
          package.itemType,
          package.sourceUuid,
        );
        return _AddablePackageItemWidget(
          package: package,
          isLoading: cubit.addingItemKey == loadingKey,
          onTap: () => _addPackageItem(context, cubit, package),
        );
      },
    );
  }

  Widget _buildCustomerPackagesContent(
    BuildContext context,
    BookingDetailsCubit cubit,
  ) {
    if (cubit.isAddableItemsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final packages = cubit.addableItems?.customerPackages ?? [];
    if (packages.isEmpty) {
      return _AddableEmptyState(
        message: context.tr('bookingDetails.noCustomerPackageBalance'),
        actionText: widget.customerUuid?.isNotEmpty == true
            ? context.tr('bookingDetails.openCustomerPackages')
            : null,
        onActionTap: widget.customerUuid?.isNotEmpty == true
            ? () async {
                await showCustomerContextBottomSheet(
                  context: context,
                  customerUuid: widget.customerUuid!,
                );
              }
            : null,
      );
    }

    return ListView.separated(
      itemCount: packages.length,
      separatorBuilder: (_, _) =>
          Divider(height: 1.h, color: AppColors.greyColorF5),
      itemBuilder: (context, index) {
        final package = packages[index];
        final loadingKey = _addableLoadingKey(
          package.itemType,
          package.sourceUuid,
        );
        return _AddableCustomerPackageItemWidget(
          package: package,
          isLoading: cubit.addingItemKey == loadingKey,
          onTap: () => _addCustomerPackageItem(context, cubit, package),
        );
      },
    );
  }

  Widget _buildFollowUpsContent(
    BuildContext context,
    BookingDetailsCubit cubit,
  ) {
    if (cubit.isAddableItemsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final followUps = cubit.addableItems?.followUps ?? [];
    if (followUps.isEmpty) {
      return _AddableEmptyState(
        message: context.tr('bookingDetails.noAddableFollowUps'),
      );
    }

    return ListView.separated(
      itemCount: followUps.length,
      separatorBuilder: (_, _) =>
          Divider(height: 1.h, color: AppColors.greyColorF5),
      itemBuilder: (context, index) {
        final followUp = followUps[index];
        final loadingKey = _addableLoadingKey(
          followUp.itemType,
          followUp.sourceUuid,
        );
        return _AddableFollowUpItemWidget(
          followUp: followUp,
          isLoading: cubit.addingItemKey == loadingKey,
          onTap: () {
            cubit.addBookingItemToVisit(
              visitUuid: widget.visitUuid ?? '',
              itemType: followUp.itemType,
              followUpUuid: followUp.sourceUuid,
              serviceUuid: followUp.service.uuid,
              loadingKey: loadingKey,
            );
          },
        );
      },
    );
  }

  Future<void> _addPackageItem(
    BuildContext context,
    BookingDetailsCubit cubit,
    BookingAddablePackageModel package,
  ) async {
    if (package.itemType == 'package_item') {
      cubit.addBookingItemToVisit(
        visitUuid: widget.visitUuid ?? '',
        itemType: package.itemType,
        packageUuid: package.sourceUuid,
        loadingKey: _addableLoadingKey(package.itemType, package.sourceUuid),
      );
      return;
    }

    final selectedService = await _pickPackageService(
      context: context,
      services: package.services,
    );
    if (selectedService == null) return;

    cubit.addBookingItemToVisit(
      visitUuid: widget.visitUuid ?? '',
      itemType: package.itemType,
      packageUuid: package.sourceUuid,
      serviceUuid: selectedService.uuid,
      bookingMode: 'purchase_and_session',
      loadingKey: _addableLoadingKey(package.itemType, package.sourceUuid),
    );
  }

  Future<void> _addCustomerPackageItem(
    BuildContext context,
    BookingDetailsCubit cubit,
    BookingAddableCustomerPackageModel package,
  ) async {
    final selectedService = await _pickPackageService(
      context: context,
      services: package.services,
    );
    if (selectedService == null) return;

    cubit.addBookingItemToVisit(
      visitUuid: widget.visitUuid ?? '',
      itemType: package.itemType,
      packagePurchaseUuid: package.sourceUuid,
      serviceUuid: selectedService.uuid,
      loadingKey: _addableLoadingKey(package.itemType, package.sourceUuid),
    );
  }

  String _addableLoadingKey(String itemType, String uuid) => '$itemType:$uuid';

  Future<BookingAddablePackageServiceModel?> _pickPackageService({
    required BuildContext context,
    required List<BookingAddablePackageServiceModel> services,
  }) async {
    if (services.length == 1) return services.first;
    if (services.isEmpty) {
      AppConstant.toast(
        context.tr('bookingDetails.noPackageServices'),
        false,
        context,
      );
      return null;
    }

    return showModalBottomSheet<BookingAddablePackageServiceModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.greyColor3004.withValues(alpha: .25),
      builder: (_) => _PackageServicePickerBottomSheet(services: services),
    );
  }
}

class _BookingAddItemTabs extends StatelessWidget {
  final _BookingAddItemTab selectedTab;
  final ValueChanged<_BookingAddItemTab> onChanged;

  const _BookingAddItemTabs({
    required this.selectedTab,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _BookingAddItemTabData(
        tab: _BookingAddItemTab.services,
        label: context.tr('bookingDetails.servicesTab'),
      ),
      _BookingAddItemTabData(
        tab: _BookingAddItemTab.packages,
        label: context.tr('bookingDetails.packagesAndOffers'),
      ),
      _BookingAddItemTabData(
        tab: _BookingAddItemTab.customerPackages,
        label: context.tr('bookingDetails.customerCurrentPackages'),
      ),
      _BookingAddItemTabData(
        tab: _BookingAddItemTab.subscriptions,
        label: context.tr('bookingDetails.followUpServices'),
      ),
    ];

    return SizedBox(
      height: 42.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, _) => horizontalSpace(8),
        itemBuilder: (context, index) {
          final item = tabs[index];
          final isSelected = selectedTab == item.tab;
          return GestureDetector(
            onTap: () => onChanged(item.tab),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.greenColor500
                    : AppColors.greyColorFA,
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Center(
                child: Text(
                  item.label,
                  style: TextStyles.font12greyColorA3W400.copyWith(
                    color: isSelected
                        ? AppColors.whiteColor
                        : AppColors.greyColor900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BookingAddItemTabData {
  final _BookingAddItemTab tab;
  final String label;

  const _BookingAddItemTabData({required this.tab, required this.label});
}

class _AddableEmptyState extends StatelessWidget {
  final String message;
  final String? actionText;
  final VoidCallback? onActionTap;

  const _AddableEmptyState({
    required this.message,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyles.font14greyColor500W500,
          ),
          if (actionText != null && onActionTap != null) ...[
            verticalSpace(16),
            InkWell(
              onTap: onActionTap,
              borderRadius: BorderRadius.circular(10.r),
              child: Container(
                height: 42.h,
                padding: EdgeInsets.symmetric(horizontal: 18.w),
                decoration: BoxDecoration(
                  color: AppColors.greenColor500,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Text(
                    actionText!,
                    style: TextStyles.font12greenColor500W600.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddableServiceItemWidget extends StatelessWidget {
  final BookingAddableServiceModel service;
  final bool isLoading;
  final VoidCallback onTap;

  const _AddableServiceItemWidget({
    required this.service,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _AddableBaseRow(
      title: service.name,
      subtitle: service.category,
      trailing: _AddableDurationText(minutes: service.durationMinutes),
      button: _AddableActionButton(isLoading: isLoading, onTap: onTap),
    );
  }
}

class _AddablePackageItemWidget extends StatelessWidget {
  final BookingAddablePackageModel package;
  final bool isLoading;
  final VoidCallback onTap;

  const _AddablePackageItemWidget({
    required this.package,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final servicesNames = package.services
        .map((service) => service.name)
        .where((name) => name.isNotEmpty)
        .join('، ');
    return _AddableBaseRow(
      title: package.name,
      subtitle: servicesNames.isEmpty
          ? _packageTypeLabel(context, package.type)
          : servicesNames,
      extra: _PackagePriceText(package: package),
      trailing: _AddableDurationText(minutes: package.totalDurationMinutes),
      button: _AddableActionButton(isLoading: isLoading, onTap: onTap),
    );
  }

  String _packageTypeLabel(BuildContext context, String type) {
    switch (type) {
      case 'multi_session':
        return context.tr('customerContext.multiSession');
      case 'usage_based':
        return context.tr('customerContext.usageBased');
      default:
        return context.tr('bookingDetails.packageBadge');
    }
  }
}

class _AddableCustomerPackageItemWidget extends StatelessWidget {
  final BookingAddableCustomerPackageModel package;
  final bool isLoading;
  final VoidCallback onTap;

  const _AddableCustomerPackageItemWidget({
    required this.package,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final balance = package.sessions ?? package.usage;
    final unit = balance?.unitName ?? balance?.unitCode ?? '';
    final available = balance?.available ?? 0;
    final servicesNames = package.services
        .map((service) => service.name)
        .where((name) => name.isNotEmpty)
        .join('، ');

    return _AddableBaseRow(
      title: package.name,
      subtitle: servicesNames.isEmpty
          ? context.tr('bookingDetails.customerCurrentPackages')
          : servicesNames,
      extra: Text(
        context.tr(
          'bookingDetails.availableBalance',
          namedArgs: {'count': '$available', 'unit': unit},
        ),
        style: TextStyles.font12greyColorA3W400.copyWith(
          color: AppColors.greenColor500,
        ),
      ),
      trailing: const _ReadOnlyBadge(),
      button: _AddableActionButton(isLoading: isLoading, onTap: onTap),
    );
  }
}

class _AddableFollowUpItemWidget extends StatelessWidget {
  final BookingAddableFollowUpModel followUp;
  final bool isLoading;
  final VoidCallback onTap;

  const _AddableFollowUpItemWidget({
    required this.followUp,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _AddableBaseRow(
      title: followUp.service.name,
      subtitle: followUp.priceType,
      extra: followUp.recommendedPeriodEnded
          ? Text(
              context.tr('bookingDetails.expiredRecommendedPeriod'),
              style: TextStyles.font12greyColorA3W400.copyWith(
                color: AppColors.warningColor1001,
              ),
            )
          : null,
      trailing: Text(
        context.tr(
          'bookingDetails.remainingUses',
          namedArgs: {'count': '${followUp.availableCount}'},
        ),
        style: TextStyles.font12greyColorA3W400,
      ),
      button: _AddableActionButton(isLoading: isLoading, onTap: onTap),
    );
  }
}

class _AddableBaseRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? extra;
  final Widget trailing;
  final Widget button;

  const _AddableBaseRow({
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.button,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      child: Row(
        children: [
          button,
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font14greyColor900Weight600,
                ),
                if (subtitle.isNotEmpty) ...[
                  verticalSpace(4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font12greyColorA3W400,
                  ),
                ],
                if (extra != null) ...[verticalSpace(6), extra!],
              ],
            ),
          ),
          horizontalSpace(8),
          trailing,
        ],
      ),
    );
  }
}

class _AddableActionButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _AddableActionButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          color: AppColors.greenColor5005,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: isLoading
            ? Padding(
                padding: EdgeInsets.all(10.r),
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(Icons.add, color: AppColors.greenColor500, size: 18.r),
      ),
    );
  }
}

class _ReadOnlyBadge extends StatelessWidget {
  const _ReadOnlyBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.greenColor5005,
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        context.tr('bookingDetails.available'),
        style: TextStyles.font12greenColor500W600,
      ),
    );
  }
}

class _AddableDurationText extends StatelessWidget {
  final int minutes;

  const _AddableDurationText({required this.minutes});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$minutes ${context.tr('bookingDetails.min')}',
      style: TextStyles.font12greyColorA3W400,
    );
  }
}

class _PackagePriceText extends StatelessWidget {
  final BookingAddablePackageModel package;

  const _PackagePriceText({required this.package});

  @override
  Widget build(BuildContext context) {
    final hasOffer =
        package.hasActiveOffer && package.basePrice != package.effectivePrice;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasOffer) ...[
          Text(
            package.basePrice,
            style: TextStyles.font12greyColorA3W400.copyWith(
              decoration: TextDecoration.lineThrough,
            ),
          ),
          horizontalSpace(8),
        ],
        Text(package.effectivePrice, style: TextStyles.font12greenColor500W600),
      ],
    );
  }
}

class _PackageServicePickerBottomSheet extends StatelessWidget {
  final List<BookingAddablePackageServiceModel> services;

  const _PackageServicePickerBottomSheet({required this.services});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 460.h),
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.greyColorE5,
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
          verticalSpace(18),
          Row(
            children: [
              Expanded(
                child: Text(
                  context.tr('bookingDetails.choosePackageService'),
                  style: TextStyles.font18greyColor900Weight600,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                  radius: 18.r,
                  backgroundColor: AppColors.greyColorF5,
                  child: Icon(
                    Icons.close,
                    color: AppColors.greyColor900,
                    size: 18.r,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(12),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: services.length,
              separatorBuilder: (_, _) =>
                  Divider(height: 1.h, color: AppColors.greyColorF5),
              itemBuilder: (context, index) {
                final service = services[index];
                return InkWell(
                  onTap: () => Navigator.pop(context, service),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    child: Row(
                      children: [
                        Container(
                          width: 38.r,
                          height: 38.r,
                          decoration: BoxDecoration(
                            color: AppColors.greenColor5005,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.add,
                            color: AppColors.greenColor500,
                            size: 18.r,
                          ),
                        ),
                        horizontalSpace(12),
                        Expanded(
                          child: Text(
                            service.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.font14greyColor900Weight600,
                          ),
                        ),
                        horizontalSpace(8),
                        _AddableDurationText(minutes: service.durationMinutes),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddServiceItemWidget extends StatelessWidget {
  final ServiceWithPriceModel service;
  final String currency;
  final bool isLoading;
  final VoidCallback onTap;

  const AddServiceItemWidget({
    super.key,
    required this.service,
    required this.currency,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Row(
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: AppColors.greenColor5005,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: isLoading
                  ? Padding(
                      padding: EdgeInsets.all(10.r),
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.add, color: AppColors.greenColor500, size: 18.r),
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font14greyColor900Weight600,
                  ),
                  verticalSpace(4),
                  Text(
                    service.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.font12greyColorA3W400,
                  ),
                ],
              ),
            ),
            horizontalSpace(8),
            Text(
              '${context.tr('bookingDetails.min')} ${service.estimatedDurationMinutes}',
              style: TextStyles.font12greyColorA3W400,
            ),
            horizontalSpace(10),
            Text(
              '$currency ${service.pricing.finalPrice}',
              style: TextStyles.font14greyColor900Weight600,
            ),
          ],
        ),
      ),
    );
  }
}
