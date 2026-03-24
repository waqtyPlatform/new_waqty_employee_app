import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/models/working_hours_response_model.dart';

class ProfileWorkingHoursItemsWidget extends StatelessWidget {
  final WorkingHoursModel items;

  const ProfileWorkingHoursItemsWidget({Key? key, required this.items})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  items.shiftDate,
                  maxLines: 1,
                  style: TextStyles.font14greyColor900Weight500,
                ),
              ),
              horizontalSpace(8),
              Text(
                '${AppConstant.convertTo12Hour( items.startTime)} - ${AppConstant.convertTo12Hour( items.endTime)}',
                maxLines: 1,
                style: TextStyles.font14greyColor900Weight500,
              ),
            ],
          ),
        ),
        Divider(color: AppColors.greyColor1001.withValues(alpha: .2))
      ],
    );
  }
}
