import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/assets_manager.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeSnapshotWidget extends StatelessWidget {
  const HomeSnapshotWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Today's Snapshot", style: TextStyles.font18greyColor900Weight600),
        verticalSpace(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSnapshotCard(
              imagePath: ImageAsset.bookedIcon,
              iconColor: AppColors.blueColor100,
              iconBgColor: AppColors.blueColor0,
              value: '7',
              label: 'Booked',
            ),
            horizontalSpace(8),
            _buildSnapshotCard(
              imagePath: ImageAsset.doneIcon,
              iconColor: AppColors.successColor100,
              iconBgColor: AppColors.successColor0,
              value: '1',
              label: 'Done',
            ),
            horizontalSpace(8),
            _buildSnapshotCard(
              imagePath: ImageAsset.leftIcon,
              iconColor: AppColors.warningColor100,
              iconBgColor: AppColors.warningColor0,
              value: '4',
              label: 'Left',
            ),
            horizontalSpace(8),
            _buildSnapshotCard(
              imagePath: ImageAsset.rateIcon,
              iconColor: AppColors.warningColor3003,
              iconBgColor:
                  AppColors.warningColor0, // Used a light warning color for bg
              value: '4.8',
              label: 'Rating',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSnapshotCard({
    required String imagePath,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            width: .8,
            color: AppColors.greyColor1001.withValues(alpha: .2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyColor900.withOpacity(0.04),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(9.r),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(imagePath, height: 20.h, width: 20.w),
            ),
            verticalSpace(6),
            Text(value, style: TextStyles.font16greyColor900Weight600),
            verticalSpace(6),
            Text(label, style: TextStyles.font10greyColor3003Weight500),
          ],
        ),
      ),
    );
  }
}
