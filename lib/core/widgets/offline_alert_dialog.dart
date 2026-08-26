import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/services/check_network.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/button_widget.dart';
import 'package:new_waqty_employee_app/my_app.dart';

class OfflineAlertDialog {
  const OfflineAlertDialog();

  static Future<void> showBottomSheet() {
    return showModalBottomSheet<void>(
      context: navigatorKey.currentContext!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.blackColor.withValues(alpha: .35),
      builder: (_) => const _OfflineBottomSheetWidget(),
    );
  }
}

class _OfflineBottomSheetWidget extends StatefulWidget {
  const _OfflineBottomSheetWidget();

  @override
  State<_OfflineBottomSheetWidget> createState() =>
      _OfflineBottomSheetWidgetState();
}

class _OfflineBottomSheetWidgetState extends State<_OfflineBottomSheetWidget> {
  bool _isLoading = false;

  Future<void> _tryAgain() async {
    setState(() => _isLoading = true);
    final isOnline = await MyConnectivity.refreshStatus();
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (isOnline) Navigator.pop(context);
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
            verticalSpace(32),
            Container(
              width: 64.r,
              height: 64.r,
              decoration: const BoxDecoration(
                color: AppColors.errorColor0,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.wifi_off_rounded,
                color: AppColors.errorColor100,
                size: 34.r,
              ),
            ),
            verticalSpace(18),
            Text(
              context.tr('common.noInternet'),
              textAlign: TextAlign.center,
              style: TextStyles.font20greyColor900W600,
            ),
            verticalSpace(10),
            Text(
              context.tr('common.noInternetText'),
              textAlign: TextAlign.center,
              style: TextStyles.font14greyColor500W400.copyWith(height: 1.5),
            ),
            verticalSpace(28),
            ButtonWidget(
              isLoading: _isLoading,
              buttonHeight: 52,
              borderRadius: 12.r,
              backGroundColor: AppColors.greenColor500,
              fourGroundColor: AppColors.whiteColor,
              buttonText: context.tr('common.tryAgain'),
              textStyle: TextStyles.font16whiteColorWeight600,
              onPressed: _isLoading ? () {} : _tryAgain,
            ),
          ],
        ),
      ),
    );
  }
}
