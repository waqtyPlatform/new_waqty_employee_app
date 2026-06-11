import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class ReportBugAppInfoWidget extends StatelessWidget {
  const ReportBugAppInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.8.w),
      decoration: BoxDecoration(
        color: AppColors.greyColorFA,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColorF5, width: 0.8.w),
      ),
      child: Row(
        children: [
          Container(
            height: 32.r,
            width: 32.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.greyColorFA,
            ),
            child: Icon(
              Icons.bug_report_outlined,
              size: 14.r,
              color: AppColors.greyColorA3,
            ),
          ),
          horizontalSpace(8),
          Expanded(
            child: Text(
              context.tr('reportBug.appInfo'),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.font10greyColorA3w400,
            ),
          ),
        ],
      ),
    );
  }
}
