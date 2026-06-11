import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class HelpSearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const HelpSearchWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: AppColors.greyColorF5),
      ),
      child: Row(
        children: [
          Icon(Icons.search, size: 24.r, color: AppColors.greyColor300),
          horizontalSpace(12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                hintText: context.tr('helpFaq.search'),
                hintStyle: TextStyles.font14greyColorA3W400,
              ),
              style: TextStyles.font14greyColor900Weight400,
            ),
          ),
          Container(
            padding: EdgeInsetsDirectional.only(start: 8.w),
            decoration: const BoxDecoration(
              border: BorderDirectional(
                start: BorderSide(color: AppColors.greyColorFA),
              ),
            ),
            child: Icon(Icons.tune, size: 22.r, color: AppColors.greyColorA3),
          ),
        ],
      ),
    );
  }
}
