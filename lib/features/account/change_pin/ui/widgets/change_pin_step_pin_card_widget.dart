import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/change_pin_step_data.dart';

class ChangePinStepPinCardWidget extends StatelessWidget {
  final ChangePinStepData data;

  const ChangePinStepPinCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: .8.w, vertical: 20.8.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColorFA, width: .8.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 72.h,
            width: 280.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ChangePinInputBoxWidget(
                      value: data.visibleDigits[index],
                      active: data.activeInputIndex == index,
                    ),
                    if (index < 3) horizontalSpace(8),
                  ],
                );
              }),
            ),
          ),
          verticalSpace(12),
          Text(
            context.tr(data.hintKey),
            textAlign: TextAlign.center,
            style: TextStyles.font12greyColorA3W400,
          ),
        ],
      ),
    );
  }
}

class ChangePinInputBoxWidget extends StatelessWidget {
  final String value;
  final bool active;

  const ChangePinInputBoxWidget({
    super.key,
    required this.value,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64.w,
      height: 72.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: active ? AppColors.greenColor500 : AppColors.greyColorE5,
          width: .8.w,
        ),
      ),
      child: Text(
        active && value.isEmpty ? '|' : value,
        textAlign: TextAlign.center,
        style: value.isEmpty
            ? TextStyles.font18greyColor900Weight600.copyWith(
                color: active ? AppColors.greyColor500 : AppColors.greyColorE5,
                fontWeight: FontWeight.w400,
              )
            : TextStyles.font32greyColor900Weight600,
      ),
    );
  }
}
