import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/assets_manager.dart';
import 'package:shimmer/shimmer.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  final String imgUrl;
  final BorderRadius radius;

  const CachedNetworkImageWidget({
    required this.imgUrl,
    required this.radius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: imgUrl,
        placeholder: (context, url) => loadingWidget(),
        errorWidget: (context, url, error) => Container(
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Image.asset(ImageAsset.logoImage, fit: BoxFit.fitWidth),
        ),
      ),
    );
  }

  Widget loadingWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withValues(alpha: .8),
      highlightColor: Colors.grey.withValues(alpha: .4),
      period: const Duration(seconds: 1),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: .6),
          borderRadius: radius,
        ),
      ),
    );
  }
}
