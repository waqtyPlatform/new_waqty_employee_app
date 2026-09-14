import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/cached_network_image.dart';

class ProfileUserDataWidget extends StatelessWidget {
  final String userName;
  final String jobTitle;
  final String userCode;
  final String branchName;
  final String profileImageUrl;
  const ProfileUserDataWidget({
    super.key,
    required this.userName,
    required this.jobTitle,
    required this.userCode,
    required this.branchName,
    this.profileImageUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ProfileAvatar(userName: userName, imageUrl: profileImageUrl),
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

class _ProfileAvatar extends StatelessWidget {
  final String userName;
  final String imageUrl;

  const _ProfileAvatar({required this.userName, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final initials =
        (userName.length >= 2 ? userName.substring(0, 2) : userName)
            .toUpperCase();

    return CircleAvatar(
      radius: 40.r,
      backgroundColor: AppColors.greenColor500,
      child: imageUrl.trim().isEmpty
          ? Text(initials, style: TextStyles.font26whiteColorWeight600)
          : SizedBox(
              width: 80.r,
              height: 80.r,
              child: CachedNetworkImageWidget(
                imgUrl: imageUrl.trim(),
                radius: BorderRadius.circular(100.r),
              ),
            ),
    );
  }
}
