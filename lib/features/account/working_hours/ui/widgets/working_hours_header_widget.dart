import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class WorkingHoursHeaderWidget extends StatelessWidget {
  const WorkingHoursHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: InkWell(
              onTap: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              borderRadius: BorderRadius.circular(40.r),
              child: Container(
                height: 48.r,
                width: 48.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.whiteColor,
                  border: Border.all(color: AppColors.greyColor50),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: AppColors.greyColor900,
                  size: 22.r,
                ),
              ),
            ),
          ),
          Text(
            context.tr('workingHours.title'),
            style: TextStyles.font18greyColor900Weight600,
          ),
        ],
      ),
    );
  }
}
