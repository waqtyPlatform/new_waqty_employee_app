import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/my_services/data/models/my_services_response_model.dart';

class ProfileServiceItemsWidget extends StatelessWidget {
  final MyServiceModel items;

  const ProfileServiceItemsWidget({Key? key, required this.items})
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
                  items.name,
                  maxLines: 1,
                  style: TextStyles.font14greyColor900Weight500,
                ),
              ),
              horizontalSpace(8),
              CircleAvatar(
                radius: 12.r,
                backgroundColor: AppColors.greenColor500.withValues(alpha: .08),
                child: Icon(
                  Icons.done,
                  size: 14.r,
                  color: AppColors.greenColor500,
                ),
              ),
            ],
          ),
        ),
        Divider(color: AppColors.greyColor1001.withValues(alpha: .2)),
      ],
    )
    //
    ;
  }
}
