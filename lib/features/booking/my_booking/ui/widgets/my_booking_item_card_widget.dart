import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/cached_network_image.dart';

class MyBookingItemCardWidget extends StatelessWidget {
  final String bookingTime;
  final int? dailyQueueNumber;
  final String bookingStatus;
  final String? bookingStatusLabel;
  final String bookingUuid;

  final String clientName;
  final String serviceName;
  final int visitsCount;
  final bool canCancel;
  final bool isCancelLoading;
  final VoidCallback? onCancelTap;

  const MyBookingItemCardWidget({
    super.key,
    required this.bookingTime,
    this.dailyQueueNumber,
    required this.bookingStatus,
    this.bookingStatusLabel,
    required this.bookingUuid,
    required this.clientName,
    required this.serviceName,
    required this.visitsCount,
    this.canCancel = false,
    this.isCancelLoading = false,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _openBookingDetails(context);
      },
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.greyColor50),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 24.r,
                    color: AppColors.greenColor500,
                  ),
                  horizontalSpace(4),
                  Text(
                    bookingTime,
                    style: _hasSingleAction
                        ? TextStyles.font12greyColor900Weight400.copyWith(
                            height: 1.55,
                          )
                        : TextStyles.font12greyColorA3W400,
                  ),
                  const Spacer(),

                  //booking status
                  Container(
                    height: 20.h,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16.r)),
                      color: _getStatusBgColor(),
                    ),
                    child: Center(
                      child: Text(
                        _getStatusLabel(context),
                        style: TextStyles.font12warningColor1001Weight500
                            .copyWith(color: _getStatusTextColor()),
                      ),
                    ),
                  ),
                  if (!_hasSingleAction && dailyQueueNumber != null) ...[
                    horizontalSpace(8),
                    //daily visit queue number
                    Container(
                      width: 24.r,
                      height: 24.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.r)),
                        border: Border.all(color: AppColors.greyColorF5),
                        color: AppColors.whiteColor,
                      ),
                      child: Center(
                        child: Text(
                          '#$dailyQueueNumber',
                          style: TextStyles.font14greenColor500Weight600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Divider(color: AppColors.greyColor50, thickness: 1),
            verticalSpace(16),

            //booking info
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: _hasSingleAction ? 80.w : 64.w,
                  height: _hasSingleAction ? 80.h : 64.h,
                  child: CachedNetworkImageWidget(
                    imgUrl:
                        'https://images.unsplash.com/photo-1599839619722-39751411ea63?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80',
                    radius: BorderRadius.circular(8.r),
                  ),
                ),
                horizontalSpace(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clientName,
                        style: TextStyles.font16greyColor900Weight600,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${context.tr('myBooking.services')}:\n ',
                              style: TextStyles.font12greyColor500W600,
                            ),
                            TextSpan(
                              text: serviceName,
                              style: TextStyles.font12greyColor500W400,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (visitsCount > 1) ...[
                        verticalSpace(4),
                        Text(
                          '${context.tr('bookingDetails.visits')}: $visitsCount',
                          style: TextStyles.font12greyColorA3W400,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (_showActionButtons) ...[
              verticalSpace(16),
              _hasSingleAction
                  ? _BookingActionButton(
                      text: context.tr('myBooking.viewDetails'),
                      backgroundColor: _isCanceled
                          ? AppColors.whiteColor
                          : AppColors.greenColor500,
                      textColor: _isCanceled
                          ? AppColors.greenColor500
                          : AppColors.whiteColor,
                      borderColor: AppColors.greenColor500,
                      onTap: () {
                        _openBookingDetails(context);
                      },
                    )
                  : _BookingActionsRow(
                      showCancel: canCancel,
                      isCancelLoading: isCancelLoading,
                      onCancelTap: () {
                        _confirmCancelVisit(context);
                      },
                      onViewDetailsTap: () {
                        _openBookingDetails(context);
                      },
                    ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusBgColor() {
    switch (bookingStatus.toLowerCase()) {
      case 'processing':
        return AppColors.warningColor1002;
      case 'upcoming':
        return AppColors.blueColor5055;
      case 'confirmed':
        return AppColors.blueColor5055;
      case 'completed':
        return AppColors.greenColor5005;
      case 'canceled':
      case 'cancelled':
        return AppColors.errorColor100;
      default:
        return AppColors.greyColor0;
    }
  }

  Color _getStatusTextColor() {
    switch (bookingStatus.toLowerCase()) {
      case 'processing':
        return AppColors.warningColor1001;
      case 'upcoming':
        return AppColors.blueColor506;
      case 'confirmed':
        return AppColors.blueColor506;
      case 'completed':
        return AppColors.greenColor500;
      case 'canceled':
      case 'cancelled':
        return AppColors.greyColor0;
      default:
        return AppColors.warningColor1002;
    }
  }

  String _getStatusLabel(BuildContext context) {
    if (bookingStatusLabel?.isNotEmpty == true) {
      return bookingStatusLabel!;
    }
    switch (bookingStatus.toLowerCase()) {
      case 'processing':
        return context.tr('myBooking.processing');
      case 'upcoming':
        return context.tr('myBooking.upcoming');
      case 'confirmed':
        return context.tr('myBooking.confirmed');
      case 'completed':
        return context.tr('myBooking.completed');
      case 'canceled':
      case 'cancelled':
        return context.tr('myBooking.cancelled');
      default:
        return context.tr('myBooking.processing');
    }
  }

  bool get _showActionButtons {
    switch (bookingStatus.toLowerCase()) {
      case 'processing':
      case 'upcoming':
      case 'confirmed':
      case 'completed':
      case 'canceled':
      case 'cancelled':
        return true;
      default:
        return false;
    }
  }

  bool get _isCompleted => bookingStatus.toLowerCase() == 'completed';

  bool get _isCanceled {
    final status = bookingStatus.toLowerCase();
    return status == 'canceled' || status == 'cancelled';
  }

  bool get _hasSingleAction => _isCompleted || _isCanceled;

  void _openBookingDetails(BuildContext context) {
    context.pushNamed(
      Routes.bookingDetailsScreen,
      arguments: {'uuid': bookingUuid},
    );
  }

  Future<void> _confirmCancelVisit(BuildContext context) async {
    if (onCancelTap == null || isCancelLoading) return;

    final shouldCancel = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.blackColor.withValues(alpha: .4),
      builder: (_) => _CancelVisitBottomSheet(
        clientName: clientName,
        bookingTime: bookingTime,
        visitsCount: visitsCount,
      ),
    );

    if (shouldCancel == true) {
      onCancelTap?.call();
    }
  }
}

class _CancelVisitBottomSheet extends StatelessWidget {
  final String clientName;
  final String bookingTime;
  final int visitsCount;

  const _CancelVisitBottomSheet({
    required this.clientName,
    required this.bookingTime,
    required this.visitsCount,
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
              '$clientName - $bookingTime',
              textAlign: TextAlign.center,
              style: TextStyles.font14greyColor500W500,
            ),
            if (visitsCount > 1) ...[
              verticalSpace(8),
              Text(
                '${context.tr('bookingDetails.visits')}: $visitsCount',
                textAlign: TextAlign.center,
                style: TextStyles.font12greyColorA3W400,
              ),
            ],
            verticalSpace(36),
            Row(
              children: [
                Expanded(
                  child: _CancelVisitSheetButtonWidget(
                    title: context.tr('bookingDetails.back'),
                    textColor: AppColors.greyColor900,
                    backgroundColor: AppColors.whiteColor,
                    borderColor: AppColors.greyColorE5,
                    onTap: () => Navigator.pop(context, false),
                  ),
                ),
                horizontalSpace(16),
                Expanded(
                  child: _CancelVisitSheetButtonWidget(
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

class _CancelVisitSheetButtonWidget extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _CancelVisitSheetButtonWidget({
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

class _BookingActionsRow extends StatelessWidget {
  final bool showCancel;
  final bool isCancelLoading;
  final VoidCallback onCancelTap;
  final VoidCallback onViewDetailsTap;

  const _BookingActionsRow({
    required this.showCancel,
    required this.isCancelLoading,
    required this.onCancelTap,
    required this.onViewDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!showCancel) {
      return _BookingActionButton(
        text: context.tr('myBooking.viewDetails'),
        backgroundColor: AppColors.greenColor500,
        textColor: AppColors.whiteColor,
        borderColor: AppColors.greenColor500,
        onTap: onViewDetailsTap,
      );
    }

    return Row(
      children: [
        Expanded(
          child: _BookingActionButton(
            text: context.tr('bookingDetails.cancelVisit'),
            backgroundColor: AppColors.errorColor2003,
            textColor: AppColors.errorColor100,
            isLoading: isCancelLoading,
            onTap: onCancelTap,
          ),
        ),
        horizontalSpace(12),
        Expanded(
          child: _BookingActionButton(
            text: context.tr('myBooking.viewDetails'),
            backgroundColor: AppColors.greenColor500,
            textColor: AppColors.whiteColor,
            borderColor: AppColors.greenColor500,
            onTap: onViewDetailsTap,
          ),
        ),
      ],
    );
  }
}

class _BookingActionButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final VoidCallback onTap;
  final bool isLoading;

  const _BookingActionButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor ?? backgroundColor),
        ),
        child: Center(child: isLoading ? _buildLoader() : _buildText()),
      ),
    );
  }

  Widget _buildLoader() {
    return SizedBox(
      width: 18.r,
      height: 18.r,
      child: CircularProgressIndicator(strokeWidth: 2, color: textColor),
    );
  }

  Widget _buildText() {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyles.font14greyColor900Weight600.copyWith(
        color: textColor,
        height: 1.55,
      ),
    );
  }
}
