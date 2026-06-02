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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
          // verticalSpace(12),
          // Align(
          //   alignment: AlignmentDirectional.centerEnd,
          //   child: _TimelineListToggle(),
          // ),
        ],
      ),
    );
  }
}
//
// class _TimelineListToggle extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 150.w,
//       height: 32.h,
//       padding: EdgeInsets.fromLTRB(3.w, 3.h, 1.w, 1.h),
//       decoration: BoxDecoration(
//         color: AppColors.greyColor25.withValues(alpha: .5),
//         borderRadius: BorderRadius.circular(100.r),
//         border: Border.all(
//           color: AppColors.greyColor1001.withValues(alpha: .1),
//           width: .8.w,
//         ),
//       ),
//       child: Row(
//         children: [
//           _TimelineListToggleButton(
//             icon: Icons.calendar_month_outlined,
//             text: 'Timeline',
//             isSelected: false,
//             width: 86.w,
//           ),
//           _TimelineListToggleButton(
//             icon: Icons.view_list_rounded,
//             text: 'List',
//             isSelected: true,
//             width: 58.w,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _TimelineListToggleButton extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final bool isSelected;
//   final double width;
//
//   const _TimelineListToggleButton({
//     required this.icon,
//     required this.text,
//     required this.isSelected,
//     required this.width,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: width,
//       height: 26.h,
//       decoration: BoxDecoration(
//         color: isSelected ? AppColors.whiteColor : Colors.transparent,
//         borderRadius: BorderRadius.circular(100.r),
//         boxShadow: isSelected
//             ? [
//                 BoxShadow(
//                   color: AppColors.greyColor900.withValues(alpha: .05),
//                   blurRadius: 1.5,
//                   offset: const Offset(0, 1),
//                 ),
//                 BoxShadow(
//                   color: AppColors.greyColor900.withValues(alpha: .04),
//                   blurRadius: 1,
//                   offset: const Offset(0, 1),
//                 ),
//               ]
//             : null,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             icon,
//             size: 16.r,
//             color: isSelected
//                 ? AppColors.greyColor900
//                 : AppColors.greyColor3003,
//           ),
//           horizontalSpace(4),
//           Text(
//             text,
//             style:
//                 (isSelected
//                         ? TextStyles.font12greyColor900Weight600
//                         : TextStyles.font12greyColor3003Weight500)
//                     .copyWith(height: 1.5),
//           ),
//         ],
//       ),
//     );
//   }
// }
