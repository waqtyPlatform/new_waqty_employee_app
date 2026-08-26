import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/assets_manager.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/cached_network_image.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String employeeName;
  final String employeeAvatarUrl;
  final String branchName;
  final VoidCallback? onAvatarTap;

  const HomeHeaderWidget({
    super.key,
    required this.employeeName,
    required this.employeeAvatarUrl,
    required this.branchName,
    this.onAvatarTap,
  });

  String get _initial {
    final name = employeeName.trim();
    return name.isEmpty ? '' : String.fromCharCode(name.runes.first);
  }

  @override
  Widget build(BuildContext context) {
    final title = branchName.trim().isEmpty ? employeeName : branchName;

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 14.h, 24.w, 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onAvatarTap,
            child: _HeaderAvatar(
              imageUrl: employeeAvatarUrl,
              initial: _initial,
            ),
          ),
          horizontalSpace(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font18whiteColorWeight600,
                ),
                verticalSpace(4),
                Text(
                  context.tr('home.branch'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font12greyColor3003Weight500,
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.greyColor800,
              border: Border.all(color: AppColors.greyColor700, width: 1.w),
            ),
            child: SvgPicture.asset(ImageAsset.notificationIcon),
          ),
        ],
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  final String imageUrl;
  final String initial;

  const _HeaderAvatar({required this.imageUrl, required this.initial});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48.w,
      height: 48.h,
      child: imageUrl.isEmpty
          ? Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.greyColor300,
              ),
              child: Text(initial, style: TextStyles.font18whiteColorWeight600),
            )
          : CachedNetworkImageWidget(
              imgUrl: imageUrl,
              radius: BorderRadius.circular(48.r),
            ),
    );
  }
}
