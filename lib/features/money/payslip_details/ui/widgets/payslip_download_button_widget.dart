import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class PayslipDownloadButtonWidget extends StatelessWidget {
  const PayslipDownloadButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.greenColor500,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.file_download_outlined, color: AppColors.whiteColor),
            horizontalSpace(8),
            Text(
              context.tr('myEarning.downloadPayslip'),
              style: TextStyles.font14greyColor900Weight600.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
