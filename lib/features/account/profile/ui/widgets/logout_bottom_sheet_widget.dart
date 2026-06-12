import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/services/cache_helper.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';

class LogoutBottomSheetWidget extends StatelessWidget {
  const LogoutBottomSheetWidget({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.blackColor.withValues(alpha: .4),
      builder: (_) => const LogoutBottomSheetWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: const Color(0xffDFE3EA),
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
            verticalSpace(36),
            _LogoutSheetTitleWidget(title: context.tr('logout.title')),
            verticalSpace(32),
            Text(
              context.tr('logout.confirmMessage'),
              textAlign: TextAlign.center,
              style: TextStyles.font18greyColor900Weight600,
            ),
            verticalSpace(32),
            Row(
              children: [
                Expanded(
                  child: _LogoutSheetButtonWidget(
                    title: context.tr('logout.cancel'),
                    textColor: AppColors.greyColor900,
                    backgroundColor: AppColors.whiteColor,
                    borderColor: AppColors.greyColorE5,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                horizontalSpace(16),
                Expanded(
                  child: _LogoutSheetButtonWidget(
                    title: context.tr('logout.logout'),
                    textColor: AppColors.whiteColor,
                    backgroundColor: AppColors.errorColor100,
                    borderColor: AppColors.errorColor100,
                    onTap: () => _logout(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await CacheHelper.removeSecureData(ConstantKeys.saveTokenToShared);
    if (!context.mounted) {
      return;
    }
    context.pushNamedAndRemoveUntil(
      Routes.loginScreen,
      predicate: (route) => false,
    );
  }
}

class _LogoutSheetTitleWidget extends StatelessWidget {
  final String title;

  const _LogoutSheetTitleWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 16.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xffECEFF3))),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyles.font18greyColor900Weight600.copyWith(
          color: AppColors.errorColor100,
        ),
      ),
    );
  }
}

class _LogoutSheetButtonWidget extends StatelessWidget {
  final String title;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback onTap;

  const _LogoutSheetButtonWidget({
    required this.title,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.greyColor900.withValues(alpha: .06),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyles.font16greyColor900Weight600.copyWith(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
