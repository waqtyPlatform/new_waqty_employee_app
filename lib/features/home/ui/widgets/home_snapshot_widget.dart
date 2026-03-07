import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

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
              icon: Icons.calendar_today,
              iconColor: AppColors.blueColor100,
              iconBgColor: AppColors.blueColor0,
              value: '7',
              label: 'Booked',
            ),
            horizontalSpace(8),
            _buildSnapshotCard(
              icon: Icons.check_circle_outline,
              iconColor: AppColors.successColor100,
              iconBgColor: AppColors.successColor0,
              value: '1',
              label: 'Done',
            ),
            horizontalSpace(8),
            _buildSnapshotCard(
              icon: Icons.timer_outlined,
              iconColor: AppColors.warningColor100,
              iconBgColor: AppColors.warningColor0,
              value: '4',
              label: 'Left',
            ),
            horizontalSpace(8),
            _buildSnapshotCard(
              icon: Icons.star_border,
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
    required IconData icon,
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
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 24.r),
            ),
            verticalSpace(6),
            Text(value, style: TextStyles.font24greyColor900Weight600),
            verticalSpace(6),
            Text(label, style: TextStyles.font15greyColor3003Weight500),
          ],
        ),
      ),
    );
  }
}
