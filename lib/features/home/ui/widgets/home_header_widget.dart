import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/assets_manager.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/widgets/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.greyColor300,
            ),
            child: CachedNetworkImageWidget(
              imgUrl: 'https://ui-avatars.com/api/?name=Aaron+Ramsdale',
              radius: BorderRadius.all(Radius.circular(24.r)),
            ),
          ),
          horizontalSpace(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, on Ramsda Hi, on Ramsda Hi, on Ramsda Hi, on Ramsda',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font18whiteColorWeight600,
                ),
                verticalSpace(4),
                Text(
                  'Maadi Branch',
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
