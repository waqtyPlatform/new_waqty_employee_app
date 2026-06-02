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
  final String bookingNumber;
  final String bookingStatus;
  final String bookingUuid;

  final String clientName;
  final String serviceName;

  const MyBookingItemCardWidget({
    super.key,
    required this.bookingTime,
    required this.bookingNumber,
    required this.bookingStatus,
    required this.bookingUuid,
    required this.clientName,
    required this.serviceName,
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
                  if (!_hasSingleAction) ...[
                    horizontalSpace(8),
                    //booking number
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
                          bookingNumber,
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
                      onCancelTap: () {},
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
}

class _BookingActionsRow extends StatelessWidget {
  final VoidCallback onCancelTap;
  final VoidCallback onViewDetailsTap;

  const _BookingActionsRow({
    required this.onCancelTap,
    required this.onViewDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _BookingActionButton(
            text: context.tr('myBooking.cancelBooking'),
            backgroundColor: AppColors.errorColor2003,
            textColor: AppColors.errorColor100,
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

  const _BookingActionButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor ?? backgroundColor),
        ),
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font14greyColor900Weight600.copyWith(
              color: textColor,
              height: 1.55,
            ),
          ),
        ),
      ),
    );
  }
}
