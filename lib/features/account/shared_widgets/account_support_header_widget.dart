import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class AccountSupportHeaderWidget extends StatelessWidget {
  final String titleKey;

  const AccountSupportHeaderWidget({super.key, required this.titleKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: SizedBox(
        height: 48.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: GestureDetector(
                onTap: () {
                  if (Navigator.canPop(context)) Navigator.pop(context);
                },
                child: Container(
                  height: 48.r,
                  width: 48.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.whiteColor,
                    border: Border.all(color: AppColors.greyColorFA),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: AppColors.greyColor900,
                    size: 24.r,
                  ),
                ),
              ),
            ),
            Text(
              context.tr(titleKey),
              style: TextStyles.font18greyColor900Weight600,
            ),
          ],
        ),
      ),
    );
  }
}
