import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/services/check_network.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/button_widget.dart';

class NoInternetScreen extends StatefulWidget {
  final Future<void> Function()? onTryAgain;

  const NoInternetScreen({super.key, this.onTryAgain});

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  bool _isLoading = false;

  Future<void> _tryAgain() async {
    setState(() => _isLoading = true);
    await MyConnectivity.refreshStatus();
    await widget.onTryAgain?.call();
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              const Spacer(flex: 2),
              const _NoInternetIconWidget(),
              verticalSpace(72),
              Text(
                context.tr('common.noInternet'),
                textAlign: TextAlign.center,
                style: TextStyles.font24greyColor900Weight600,
              ),
              verticalSpace(16),
              Text(
                context.tr('common.noInternetText'),
                textAlign: TextAlign.center,
                style: TextStyles.font14greyColor500W400.copyWith(height: 1.5),
              ),
              const Spacer(flex: 3),
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
              verticalSpace(24),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoInternetIconWidget extends StatelessWidget {
  const _NoInternetIconWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 224.w,
      height: 164.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.wifi_rounded, size: 172.r, color: AppColors.greenColor500),
          Positioned(
            right: 10.w,
            top: 8.h,
            child: Container(
              width: 76.r,
              height: 76.r,
              decoration: const BoxDecoration(
                color: Color(0xffF4511E),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close_rounded,
                color: AppColors.whiteColor,
                size: 52.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
