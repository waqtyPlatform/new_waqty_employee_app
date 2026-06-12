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
    super.key,
    required this.userName,
    required this.jobTitle,
    required this.userCode,
    required this.branchName,
  });

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
                  Flexible(
                    child: Text(
                      jobTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.font14greenColor500W500,
                    ),
                  ),
                  if (jobTitle.isNotEmpty && userCode.isNotEmpty) ...[
                    horizontalSpace(4),
                    Icon(Icons.circle, color: AppColors.greyColorA3, size: 4.r),
                    horizontalSpace(4),
                  ],
                  Flexible(
                    child: Text(
                      userCode,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
