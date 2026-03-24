import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/models/profile_response_model.dart';

class UserDataWidget extends StatelessWidget {
  final ProfileCustomer item;

  const UserDataWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColorFA, width: 0.8.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withOpacity(0.04),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Full Name',
                    maxLines: 1,
                    style: TextStyles.font10greyColorA3W600,
                  ),
                  verticalSpace(4),
                  Text(
                    item.name,
                    maxLines: 1,
                    style: TextStyles.font14greyColor900Weight500,
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.greyColor1001.withValues(alpha: .2)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phone Number',
                    maxLines: 1,
                    style: TextStyles.font10greyColorA3W600,
                  ),
                  verticalSpace(4),
                  Text(
                    item.phone,
                    maxLines: 1,
                    style: TextStyles.font14greyColor900Weight500,
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.greyColor1001.withValues(alpha: .2)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    maxLines: 1,
                    style: TextStyles.font10greyColorA3W600,
                  ),
                  verticalSpace(4),
                  Text(
                    item.email,
                    maxLines: 1,
                    style: TextStyles.font14greyColor900Weight500,
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.greyColor1001.withValues(alpha: .2)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Branch Name',
                    maxLines: 1,
                    style: TextStyles.font10greyColorA3W600,
                  ),
                  verticalSpace(4),
                  Text(
                    item.branchModel.name,
                    maxLines: 1,
                    style: TextStyles.font14greyColor900Weight500,
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.greyColor1001.withValues(alpha: .2)),
        

          ],
        ),
      ),
    );
  }
}
