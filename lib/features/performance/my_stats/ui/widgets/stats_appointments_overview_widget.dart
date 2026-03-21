import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class StatsAppointmentsOverviewWidget extends StatelessWidget {
  final double heightValueInGraph;
  const StatsAppointmentsOverviewWidget({
    super.key,
    required this.heightValueInGraph,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: AppColors.greyColor1001.withValues(alpha: .2),
          width: .8,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .04),
            blurRadius: 2,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .05),
            blurRadius: 3,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointments Overview',
            style: TextStyles.font14greyColor900Weight500,
          ),
          verticalSpace(12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Y-axis labels
              SizedBox(
                height: 140.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    double val =
                        heightValueInGraph - (index * (heightValueInGraph / 4));
                    String text = val == val.toInt()
                        ? val.toInt().toString()
                        : val.toStringAsFixed(1);
                    return Text(text, style: TextStyles.font10greyColorA3w400);
                  }),
                ),
              ),
              horizontalSpace(12),
              // Graph area
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildDayColumn('Mon', 5, heightValueInGraph),
                    _buildDayColumn('Tue', 5, heightValueInGraph),
                    _buildDayColumn('Wed', 15, heightValueInGraph),
                    _buildDayColumn('Thu', 7, heightValueInGraph),
                    _buildDayColumn('Fri', 4, heightValueInGraph),
                    _buildDayColumn('Sat', 6, heightValueInGraph),
                    _buildDayColumn('Sun', 4, 8),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayColumn(String label, int value1, double height) {
    // Max value is 8, height is 140.h
    final double heightPerUnit = 140.h / height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 140.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: value1 * heightPerUnit,
                width: 18.w,
                decoration: BoxDecoration(
                  color: AppColors.greenColor500,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.r),
                    topRight: Radius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
        ),
        verticalSpace(8),
        Text(label, style: TextStyles.font10greyColorA3w400),
      ],
    );
  }
}
