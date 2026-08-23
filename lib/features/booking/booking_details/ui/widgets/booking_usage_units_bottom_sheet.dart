import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_details_response_model.dart';

Future<int?> showBookingUsageUnitsBottomSheet(
  BuildContext context,
  BookingServiceLine service,
) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _BookingUsageUnitsBottomSheet(service: service),
  );
}

class _BookingUsageUnitsBottomSheet extends StatefulWidget {
  final BookingServiceLine service;

  const _BookingUsageUnitsBottomSheet({required this.service});

  @override
  State<_BookingUsageUnitsBottomSheet> createState() =>
      _BookingUsageUnitsBottomSheetState();
}

class _BookingUsageUnitsBottomSheetState
    extends State<_BookingUsageUnitsBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final availableUnits = widget.service.usagePackage?.availableUnits ?? 0;
    final unitName = widget.service.usagePackage?.unitName ?? '';
    final usedUnits = int.tryParse(_controller.text) ?? 0;
    final remaining = availableUnits - usedUnits;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 28.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 68.w,
                  height: 5.h,
                  decoration: BoxDecoration(
                    color: AppColors.greyColorE5,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                ),
              ),
              verticalSpace(24),
              Text(
                context.tr('bookingDetails.usageUnitsTitle'),
                style: TextStyles.font18greyColor900Weight600,
              ),
              verticalSpace(12),
              _InfoLine(
                label: context.tr('bookingDetails.availableBalanceLabel'),
                value: '$availableUnits $unitName',
              ),
              verticalSpace(14),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: context.tr('bookingDetails.unitsUsedHint'),
                  filled: true,
                  fillColor: AppColors.whiteColor,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: AppColors.greyColorE5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: AppColors.greyColorE5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: AppColors.greenColor500),
                  ),
                ),
              ),
              verticalSpace(12),
              _InfoLine(
                label: context.tr('bookingDetails.remainingAfterExecution'),
                value: '${remaining < 0 ? 0 : remaining} $unitName',
              ),
              verticalSpace(22),
              GestureDetector(
                onTap: usedUnits <= 0
                    ? null
                    : () => Navigator.pop(context, usedUnits),
                child: Container(
                  height: 48.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: usedUnits <= 0
                        ? AppColors.greyColorA3
                        : AppColors.greenColor500,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    context.tr('bookingDetails.endService'),
                    style: TextStyles.font16greyColor900Weight600.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: TextStyles.font12greyColorA3W400)),
        Text(value, style: TextStyles.font14greyColor900Weight600),
      ],
    );
  }
}
