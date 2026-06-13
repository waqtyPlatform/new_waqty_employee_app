import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/change_pin_step_data.dart';

class ChangePinInfoCardWidget extends StatelessWidget {
  final ChangePinStepData data;

  const ChangePinInfoCardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 64.h),
      padding: EdgeInsets.symmetric(horizontal: 16.8.w, vertical: 10.h),
      decoration: _changePinCardDecoration(),
      child: Row(
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              color: AppColors.greenColor500.withValues(alpha: .06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shield_outlined,
              size: 15.r,
              color: AppColors.greenColor500,
            ),
          ),
          horizontalSpace(8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr(data.titleKey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font14greyColor900Weight600,
                ),
                verticalSpace(2),
                Text(
                  context.tr(data.subtitleKey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font12greyColorA3W400,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _changePinCardDecoration() {
  return BoxDecoration(
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
  );
}
