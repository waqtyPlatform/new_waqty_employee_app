import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_details_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_cubit.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_state.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_action_buttons_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_add_service_bottom_sheet.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_appointment_completed_succesfully_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_appointment_info_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_customer_visits_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_review_user_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_services_widget.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_usage_units_bottom_sheet.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_user_info_widget.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/logic/customer_context_cubit.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/logic/customer_context_state.dart';
import 'package:new_waqty_employee_app/features/booking/customer_context/ui/widgets/customer_context_bottom_sheet.dart';

class BookingDetailsBodyWidget extends StatelessWidget {
  const BookingDetailsBodyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingDetailsCubit, BookingDetailsState>(
      listenWhen: (previous, current) => current is OnBookingDetailsErrorState,
      listener: (context, state) {
        final cubit = BookingDetailsCubit.get(context);
        final customerUuid = cubit.bookingDetails?.customer?.uuid ?? '';
        if (!cubit.hasInsufficientUsageBalanceError || customerUuid.isEmpty) {
          return;
        }
        _showInsufficientBalanceDialog(context, customerUuid, cubit);
      },
      buildWhen: (previous, current) {
        return current is OnBookingDetailsLoadingState ||
            current is OnBookingDetailsSuccessState ||
            current is OnBookingDetailsStatusLoadingState ||
            current is OnBookingDetailsStatusSuccessState ||
            current is OnBookingVisitActionLoadingState ||
            current is OnBookingVisitActionSuccessState ||
            current is OnBookingItemActionLoadingState ||
            current is OnBookingItemActionSuccessState ||
            current is OnCustomerReviewLoadingState ||
            current is OnCustomerReviewSuccessState ||
            current is OnBookingDetailsErrorState ||
            current is OnBookingDetailsCatchErrorState;
      },
      builder: (context, state) {
        final cubit = BookingDetailsCubit.get(context);
        final booking = cubit.bookingDetails;

        if (state is OnBookingDetailsLoadingState && booking == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (booking == null) {
          return RefreshIndicator(
            onRefresh: cubit.refreshBookingDetails,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 400.h,
                child: Center(
                  child: Text(
                    context.tr('bookingDetails.notFound'),
                    style: TextStyles.font14greyColor500W500,
                  ),
                ),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: cubit.refreshBookingDetails,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: _BookingDetailsContent(booking: booking, cubit: cubit),
          ),
        );
      },
    );
  }

  Future<void> _showInsufficientBalanceDialog(
    BuildContext context,
    String customerUuid,
    BookingDetailsCubit cubit,
  ) async {
    final openPackages = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.blackColor.withValues(alpha: .4),
      builder: (_) => BlocProvider(
        create: (_) => CustomerContextCubit(getIt())
          ..getCustomerContext(
            customerUuid: customerUuid,
            languageCode: context.locale.languageCode,
          ),
        child: const _InsufficientUsageBalanceSheet(),
      ),
    );

    if (openPackages == true && context.mounted) {
      final didAddPackage = await showCustomerContextBottomSheet(
        context: context,
        customerUuid: customerUuid,
        startWithAddPackage: true,
      );
      if (didAddPackage == true && context.mounted) {
        cubit.refreshBookingDetails();
      }
    }
  }
}

class _InsufficientUsageBalanceSheet extends StatelessWidget {
  const _InsufficientUsageBalanceSheet();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerContextCubit, CustomerContextState>(
      buildWhen: (previous, current) {
        return current is CustomerContextLoadingState ||
            current is CustomerContextSuccessState ||
            current is CustomerContextErrorState;
      },
      builder: (context, state) {
        final cubit = CustomerContextCubit.get(context);
        final canAddPackage =
            cubit.contextData?.capabilities.canAssignCustomerPackage == true;
        final isLoading =
            state is CustomerContextLoadingState && cubit.contextData == null;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 34.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffDFE3EA),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
                verticalSpace(30),
                Container(
                  width: 56.r,
                  height: 56.r,
                  decoration: BoxDecoration(
                    color: AppColors.warningColor0,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.warningColor1001,
                    size: 26.r,
                  ),
                ),
                verticalSpace(18),
                Text(
                  context.tr('bookingDetails.insufficientUsageBalance'),
                  textAlign: TextAlign.center,
                  style: TextStyles.font18greyColor900Weight600,
                ),
                verticalSpace(10),
                Text(
                  isLoading
                      ? context.tr('customerContext.loading')
                      : context.tr(
                          'customerContext.insufficientBalanceMessage',
                        ),
                  textAlign: TextAlign.center,
                  style: TextStyles.font14greyColor500W500.copyWith(
                    height: 1.45,
                  ),
                ),
                if (isLoading) ...[
                  verticalSpace(18),
                  SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.greenColor500,
                    ),
                  ),
                ],
                verticalSpace(28),
                Row(
                  children: [
                    Expanded(
                      child: _CancelVisitSheetButton(
                        title: context.tr('bookingDetails.back'),
                        textColor: AppColors.greyColor900,
                        backgroundColor: AppColors.whiteColor,
                        borderColor: AppColors.greyColorE5,
                        onTap: () => Navigator.pop(context, false),
                      ),
                    ),
                    if (canAddPackage) ...[
                      horizontalSpace(16),
                      Expanded(
                        child: _CancelVisitSheetButton(
                          title: context.tr(
                            'customerContext.addPackageForCustomer',
                          ),
                          textColor: AppColors.whiteColor,
                          backgroundColor: AppColors.greenColor500,
                          borderColor: AppColors.greenColor500,
                          onTap: () => Navigator.pop(context, true),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BookingDetailsContent extends StatelessWidget {
  final BookingDetailsModel booking;
  final BookingDetailsCubit cubit;

  const _BookingDetailsContent({required this.booking, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final customerName = booking.customerName.isEmpty
        ? context.tr('myBooking.walkInCustomer')
        : booking.customerName;
    final canAddItems = _canAddItemsToBooking;
    return Column(
      children: [
        verticalSpace(8),
        BookingUserInfoWidget(
          bookingStatus: booking.employeeStatus.isNotEmpty
              ? booking.employeeStatus
              : booking.status,
          bookingStatusLabel: booking.statusLabel,
          bookingId: booking.bookingNumber,
          userName: customerName,
        ),
        if (booking.visits.isEmpty) ...[
          verticalSpace(12),
          BookingAppointmentInfoWidget(
            bookingDate: _formatBookingDate(booking.bookingDate, context),
            bookingTime: _formatBookingTime(booking, context),
            roomAddress: booking.branch.name,
          ),
          verticalSpace(12),
          BookingServicesWidget(
            services: booking.serviceLinesForDetails(
              context.locale.languageCode,
            ),
            loadingItemUuid: cubit.updatingItemUuid,
            onStartService: (service) =>
                cubit.startBookingItem(service.itemUuid),
            onEndService: (service) => _endService(context, cubit, service),
            onAddTap: canAddItems
                ? () => showAddServiceBottomSheet(
                    context,
                    cubit,
                    booking.totals.currency.isNotEmpty
                        ? booking.totals.currency
                        : booking.currency,
                    null,
                    booking.customer?.uuid ?? booking.user?.uuid,
                  )
                : null,
          ),
        ] else
          ...booking.visits.map(
            (visit) => Padding(
              key: ValueKey(visit.uuid ?? visit.number),
              padding: EdgeInsets.only(top: 12.h),
              child: _BookingVisitCard(
                visit: visit,
                customerName: customerName,
                onAddTap: canAddItems
                    ? () => showAddServiceBottomSheet(
                        context,
                        cubit,
                        visit.totals.currency,
                        visit.uuid,
                        booking.customer?.uuid ?? booking.user?.uuid,
                      )
                    : null,
                cubit: cubit,
              ),
            ),
          ),
        verticalSpace(12),
        BookingCustomerVisitsWidget(
          phone: booking.customer?.phone ?? booking.user?.phone ?? '',
          notes: booking.notes ?? '',
          onCustomerDetailsTap: (booking.customer?.uuid ?? '').isEmpty
              ? null
              : () => showCustomerContextBottomSheet(
                  context: context,
                  customerUuid: booking.customer!.uuid,
                ),
        ),
        if (booking.status.toLowerCase() == 'completed') ...[
          verticalSpace(12),
          BookingAppointmentCompletedSuccesfullyWidget(
            bookingStatus: booking.status,
          ),
        ],
        if (booking.visits.isEmpty) ...[
          verticalSpace(12),
          BookingActionButtonsWidget(cubit: cubit),
        ],
        verticalSpace(8),
      ],
    );
  }

  bool get _canAddItemsToBooking {
    final status = booking.status.toLowerCase();
    final employeeStatus = booking.employeeStatus.toLowerCase();
    final paymentStatus = booking.paymentStatus.toLowerCase();
    final isCancelled =
        status == 'cancelled' ||
        status == 'canceled' ||
        status == 'no_show' ||
        employeeStatus == 'cancelled' ||
        employeeStatus == 'canceled' ||
        employeeStatus == 'no_show';
    if (isCancelled) return false;

    final isCompleted = status == 'completed' || employeeStatus == 'completed';
    final isPaid = paymentStatus == 'paid';
    if (isCompleted && isPaid) return false;

    return booking.actions.canAddService || !isPaid || !isCompleted;
  }

  String _formatBookingDate(String value, BuildContext context) {
    final date = AppDateFormat.parseBackendDateTime(value);
    if (date == null) return value;

    return AppDateFormat.dayMonth(context, date);
  }

  String _formatBookingTime(BookingDetailsModel booking, BuildContext context) {
    return '${booking.formattedStartTime} - ${booking.formattedEndTime} \u2022 ${booking.durationMinutes} ${context.tr('bookingDetails.minutes')}';
  }

  Future<void> _endService(
    BuildContext context,
    BookingDetailsCubit cubit,
    BookingServiceLine service,
  ) async {
    if (service.isUsageBased && service.usageRecordingRequired) {
      final units = await showBookingUsageUnitsBottomSheet(context, service);
      if (units == null || !context.mounted) return;
      cubit.endBookingItem(service.itemUuid, unitsConsumed: units);
      return;
    }
    cubit.endBookingItem(service.itemUuid);
  }
}

class _BookingVisitCard extends StatelessWidget {
  final BookingVisitModel visit;
  final String customerName;
  final VoidCallback? onAddTap;
  final BookingDetailsCubit cubit;

  const _BookingVisitCard({
    required this.visit,
    required this.customerName,
    required this.onAddTap,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(
          color: AppColors.greyColor1001.withValues(alpha: .2),
          width: .8,
        ),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${context.tr('bookingDetails.visit')} ${visit.number}',
                style: TextStyles.font14greyColor900Weight600,
              ),
              const Spacer(),
              if (visit.actions.canCancel) ...[
                GestureDetector(
                  onTap: cubit.updatingVisitUuid == visit.uuid
                      ? null
                      : () => _confirmCancelVisit(context),
                  child: Container(
                    width: 30.r,
                    height: 30.r,
                    decoration: BoxDecoration(
                      color: AppColors.errorColor2003,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: cubit.updatingVisitUuid == visit.uuid
                        ? Padding(
                            padding: EdgeInsets.all(8.r),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.errorColor2002,
                            ),
                          )
                        : Icon(
                            Icons.close,
                            color: AppColors.errorColor2002,
                            size: 18.r,
                          ),
                  ),
                ),
                horizontalSpace(8),
              ],
              _VisitStatusPill(status: visit.status),
            ],
          ),
          verticalSpace(10),
          _VisitInfoLine(
            icon: Icons.location_on_outlined,
            text: visit.branch?.name ?? '-',
          ),
          verticalSpace(8),
          _VisitInfoLine(
            icon: Icons.access_time,
            text: _formatVisitRange(context),
          ),
          verticalSpace(8),
          Wrap(
            spacing: 8.w,
            runSpacing: 6.h,
            children: [
              _VisitMetric(
                label: context.tr('bookingDetails.plannedDuration'),
                value:
                    '${visit.plannedDurationMinutes} ${context.tr('bookingDetails.min')}',
              ),
              _VisitMetric(
                label: context.tr('bookingDetails.actualDuration'),
                value: visit.actualDurationMinutes > 0
                    ? '${visit.actualDurationMinutes} ${context.tr('bookingDetails.min')}'
                    : '-',
              ),
              _VisitMetric(
                label: context.tr('bookingDetails.waiting'),
                value: visit.waitingTimeMinutes == null
                    ? '-'
                    : '${visit.waitingTimeMinutes} ${context.tr('bookingDetails.min')}',
              ),
              _VisitMetric(
                label: context.tr('bookingDetails.lateness'),
                value: visit.customerLatenessMinutes == null
                    ? '-'
                    : '${visit.customerLatenessMinutes} ${context.tr('bookingDetails.min')}',
              ),
            ],
          ),
          verticalSpace(12),
          BookingServicesWidget(
            services: visit.services,
            onAddTap: onAddTap,
            loadingItemUuid: cubit.updatingItemUuid,
            onStartService: (service) =>
                cubit.startBookingItem(service.itemUuid),
            onEndService: (service) => _endService(context, service),
          ),
          if (visit.customerReview != null ||
              visit.actions.canReviewCustomer) ...[
            verticalSpace(12),
            BookingReviewUserWidget(
              key: ValueKey(
                '${visit.uuid}_${visit.customerReview?.updatedAt ?? 'new'}',
              ),
              userName: customerName,
              review: visit.customerReview,
              isLoading: cubit.reviewingVisitUuid == visit.uuid,
              onSubmit: visit.actions.canReviewCustomer
                  ? (rating, comment) => cubit.submitCustomerReview(
                      visitUuid: visit.uuid ?? '',
                      rating: rating,
                      comment: comment,
                    )
                  : null,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _confirmCancelVisit(BuildContext context) async {
    final shouldCancel = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.blackColor.withValues(alpha: .4),
      builder: (_) => _CancelVisitConfirmationSheet(
        visitTitle: '${context.tr('bookingDetails.visit')} ${visit.number}',
        visitTime: _formatVisitRange(context),
      ),
    );

    if (shouldCancel == true && context.mounted) {
      cubit.cancelVisit(visit.uuid ?? '');
    }
  }

  Future<void> _endService(
    BuildContext context,
    BookingServiceLine service,
  ) async {
    if (service.isUsageBased && service.usageRecordingRequired) {
      final units = await showBookingUsageUnitsBottomSheet(context, service);
      if (units == null || !context.mounted) return;
      cubit.endBookingItem(service.itemUuid, unitsConsumed: units);
      return;
    }
    cubit.endBookingItem(service.itemUuid);
  }

  String _formatVisitRange(BuildContext context) {
    final start = _formatDateTime(context, visit.scheduledStartAt);
    final end = _formatDateTime(context, visit.scheduledEndAt, timeOnly: true);
    if (start.isEmpty && end.isEmpty) return '-';
    return '$start - $end';
  }

  String _formatDateTime(
    BuildContext context,
    String value, {
    bool timeOnly = false,
  }) {
    final date = AppDateFormat.parseBackendDateTime(value);
    if (date == null) return '';
    return timeOnly
        ? AppDateFormat.time(context, date)
        : AppDateFormat.dayMonthTime(context, date);
  }
}

class _CancelVisitConfirmationSheet extends StatelessWidget {
  final String visitTitle;
  final String visitTime;

  const _CancelVisitConfirmationSheet({
    required this.visitTitle,
    required this.visitTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 34.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: const Color(0xffDFE3EA),
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
            verticalSpace(34),
            Text(
              context.tr('bookingDetails.cancelVisit'),
              textAlign: TextAlign.center,
              style: TextStyles.font16greyColor900Weight600.copyWith(
                color: AppColors.errorColor100,
              ),
            ),
            verticalSpace(22),
            Divider(color: AppColors.greyColorF5, height: 1.h),
            verticalSpace(28),
            Text(
              context.tr('bookingDetails.confirmCancelVisit'),
              textAlign: TextAlign.center,
              style: TextStyles.font18greyColor900Weight600.copyWith(
                height: 1.45,
              ),
            ),
            verticalSpace(10),
            Text(
              '$visitTitle - $visitTime',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.font14greyColor500W500,
            ),
            verticalSpace(36),
            Row(
              children: [
                Expanded(
                  child: _CancelVisitSheetButton(
                    title: context.tr('bookingDetails.back'),
                    textColor: AppColors.greyColor900,
                    backgroundColor: AppColors.whiteColor,
                    borderColor: AppColors.greyColorE5,
                    onTap: () => Navigator.pop(context, false),
                  ),
                ),
                horizontalSpace(16),
                Expanded(
                  child: _CancelVisitSheetButton(
                    title: context.tr('bookingDetails.cancelVisit'),
                    textColor: AppColors.whiteColor,
                    backgroundColor: AppColors.errorColor100,
                    borderColor: AppColors.errorColor100,
                    onTap: () => Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CancelVisitSheetButton extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _CancelVisitSheetButton({
    required this.title,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyColor900.withValues(alpha: .06),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyles.font16greyColor900Weight600.copyWith(
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class _VisitInfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _VisitInfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.r, color: AppColors.greyColorA3),
        horizontalSpace(6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font12greyColorA3W400,
          ),
        ),
      ],
    );
  }
}

class _VisitMetric extends StatelessWidget {
  final String label;
  final String value;

  const _VisitMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.greyColorF5,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text('$label: $value', style: TextStyles.font12greyColorA3W400),
    );
  }
}

class _VisitStatusPill extends StatelessWidget {
  final String status;

  const _VisitStatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.blueColor5055,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        _statusLabel(context),
        style: TextStyles.font12warningColor1001Weight500.copyWith(
          color: AppColors.blueColor506,
        ),
      ),
    );
  }

  String _statusLabel(BuildContext context) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return context.tr('myBooking.confirmed');
      case 'completed':
        return context.tr('myBooking.completed');
      case 'cancelled':
      case 'canceled':
        return context.tr('myBooking.cancelled');
      default:
        return status.isEmpty ? '-' : status;
    }
  }
}
