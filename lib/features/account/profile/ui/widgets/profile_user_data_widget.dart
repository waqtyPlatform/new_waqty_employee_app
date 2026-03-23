import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class ProfileUserDataWidget extends StatelessWidget {
  final String userName;
  final String jobTitle;
  final String userCode;
  final String branchName;
  const ProfileUserDataWidget({
    Key? key,
    required this.userName,
    required this.jobTitle,
    required this.userCode,
    required this.branchName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40.r,
          backgroundColor: AppColors.greenColor500,
          child: Text(
            (userName.length >= 2 ? userName.substring(0, 2) : userName)
                .toUpperCase(),
            style: TextStyles.font26whiteColorWeight600,
          ),
        ),
        horizontalSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.font18greyColor900Weight600,
              ),
              verticalSpace(4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      jobTitle,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      style: TextStyles.font14greenColor500W500,
                    ),
                  ),
                  horizontalSpace(4),
                  Icon(Icons.circle, color: AppColors.greyColorA3, size: 5.r),
                  horizontalSpace(4),
                  Expanded(
                    child: Text(
                      userCode,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      style: TextStyles.font12greyColorA3W400,
                    ),
                  ),
                ],
              ),
              verticalSpace(4),
              Text(
                branchName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.font12greyColorA3W400,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
