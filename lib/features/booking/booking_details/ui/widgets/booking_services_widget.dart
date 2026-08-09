import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_details_response_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingServicesWidget extends StatelessWidget {
  final List<BookingServiceLine> services;
  final VoidCallback? onAddTap;
  final void Function(BookingServiceLine service)? onStartService;
  final void Function(BookingServiceLine service)? onEndService;
  final String? loadingItemUuid;

  const BookingServicesWidget({
    super.key,
    required this.services,
    required this.onAddTap,
    this.onStartService,
    this.onEndService,
    this.loadingItemUuid,
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
            color: AppColors.greyColor900.withValues(alpha: 0.03),
            blurRadius: 16,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: 0.04),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.tr('myBooking.services'),
                style: TextStyles.font14greyColor900Weight500,
              ),
              Spacer(flex: 1),
              if (onAddTap != null)
                GestureDetector(
                  onTap: onAddTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30.r)),
                      color: AppColors.greenColor5005,
                    ),
                    child: Text(
                      '+ ${context.tr('bookingDetails.add')}',
                      style: TextStyles.font12greenColor500W600,
                    ),
                  ),
                ),
            ],
          ),
          verticalSpace(12),
          if (services.isEmpty)
            Text(
              context.tr('bookingDetails.noServicesFound'),
              style: TextStyles.font12greyColorA3W400,
            )
          else
            ...List.generate(services.length, (index) {
              final service = services[index];
              return Column(
                children: [
                  _BookingServiceLineRow(
                    service: service,
                    isLoading: loadingItemUuid == service.itemUuid,
                    onStartService: onStartService,
                    onEndService: onEndService,
                  ),
                  if (index != services.length - 1) ...[
                    verticalSpace(12),
                    Divider(color: AppColors.greyColorF5, thickness: 1),
                    verticalSpace(12),
                  ],
                ],
              );
            }),
        ],
      ),
    );
  }
}

class _BookingServiceLineRow extends StatelessWidget {
  final BookingServiceLine service;
  final bool isLoading;
  final void Function(BookingServiceLine service)? onStartService;
  final void Function(BookingServiceLine service)? onEndService;

  const _BookingServiceLineRow({
    required this.service,
    required this.isLoading,
    this.onStartService,
    this.onEndService,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 3.r, backgroundColor: AppColors.greenColor500),
        horizontalSpace(6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      service.name?.isNotEmpty == true ? service.name! : '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.font14greyColor900Weight400,
                    ),
                  ),
                  if (service.isAdded) ...[
                    horizontalSpace(6),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.greenColor5005,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        context.tr('bookingDetails.added'),
                        style: TextStyles.font10greyColorA3W600.copyWith(
                          color: AppColors.greenColor500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (_serviceMeta(context).isNotEmpty) ...[
                verticalSpace(4),
                Text(
                  _serviceMeta(context),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font12greyColorA3W400,
                ),
              ],
              if (service.canStart || service.canEnd) ...[
                verticalSpace(8),
                _ServiceActionButton(
                  text: service.canStart
                      ? context.tr('bookingDetails.startService')
                      : context.tr('bookingDetails.endService'),
                  isLoading: isLoading,
                  onTap: service.canStart
                      ? () => onStartService?.call(service)
                      : () => onEndService?.call(service),
                ),
              ],
            ],
          ),
        ),
        horizontalSpace(8),
        Text(
          '${service.durationMinutes} ${context.tr('bookingDetails.min')}',
          style: TextStyles.font12greyColorA3W400,
        ),
      ],
    );
  }

  String _serviceMeta(BuildContext context) {
    final parts = <String>[];
    if (service.employee?.name.isNotEmpty == true) {
      parts.add(service.employee!.name);
    }
    final start = _formatTime(service.scheduledStartAt);
    final end = _formatTime(service.scheduledEndAt);
    if (start.isNotEmpty || end.isNotEmpty) {
      parts.add('$start - $end');
    }
    if (service.status.isNotEmpty) {
      parts.add(_statusLabel(context));
    }
    return parts.join(' • ');
  }

  String _formatTime(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return '';
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour < 12 ? 'AM' : 'PM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:$minute $period';
  }

  String _statusLabel(BuildContext context) {
    switch (service.status.toLowerCase()) {
      case 'confirmed':
        return context.tr('myBooking.confirmed');
      case 'completed':
        return context.tr('myBooking.completed');
      case 'cancelled':
      case 'canceled':
        return context.tr('myBooking.cancelled');
      default:
        return service.status;
    }
  }
}

class _ServiceActionButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onTap;

  const _ServiceActionButton({
    required this.text,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 30.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: AppColors.greenColor500,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 14.r,
                  height: 14.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.whiteColor,
                  ),
                )
              : Text(
                  text,
                  style: TextStyles.font12greenColor500W600.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
        ),
      ),
    );
  }
}
