import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:pinput/pinput.dart';

class AppPinCodeFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintKey;
  final bool autofocus;
  final VoidCallback? onCompleted;

  const AppPinCodeFieldWidget({
    super.key,
    required this.controller,
    required this.hintKey,
    this.autofocus = false,
    this.onCompleted,
  });

  @override
  State<AppPinCodeFieldWidget> createState() => _AppPinCodeFieldWidgetState();
}

class _AppPinCodeFieldWidgetState extends State<AppPinCodeFieldWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _requestFocusIfNeeded();
  }

  @override
  void didUpdateWidget(covariant AppPinCodeFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autofocus && !oldWidget.autofocus) {
      _requestFocusIfNeeded();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _requestFocusIfNeeded() {
    if (!widget.autofocus) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = _pinTheme(
      backgroundColor: AppColors.whiteColor,
      borderColor: AppColors.greyColorE5,
      textStyle: TextStyles.font32greyColor900Weight600,
    );
    final focusedPinTheme = _pinTheme(
      backgroundColor: AppColors.whiteColor,
      borderColor: AppColors.greenColor500,
      textStyle: TextStyles.font18greyColor900Weight600.copyWith(
        color: AppColors.greyColor500,
        fontWeight: FontWeight.w400,
      ),
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: .8.w, vertical: 20.8.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColorFA, width: .8.w),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyColor900.withValues(alpha: .04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Directionality(
            textDirection: ui.TextDirection.ltr,
            child: Pinput(
              length: 4,
              controller: widget.controller,
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              enableSuggestions: false,
              showCursor: true,
              keyboardType: TextInputType.number,
              mainAxisAlignment: MainAxisAlignment.center,
              separatorBuilder: (_) => horizontalSpace(8),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              pinputAutovalidateMode: PinputAutovalidateMode.disabled,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: defaultPinTheme,
              followingPinTheme: defaultPinTheme,
              cursor: Text(
                '|',
                style: TextStyles.font18greyColor900Weight600.copyWith(
                  color: AppColors.greyColor500,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onChanged: (_) {
                if (mounted) setState(() {});
              },
              onCompleted: (_) => widget.onCompleted?.call(),
            ),
          ),
          verticalSpace(12),
          Text(
            context.tr(widget.hintKey),
            textAlign: TextAlign.center,
            style: TextStyles.font12greyColorA3W400,
          ),
        ],
      ),
    );
  }

  PinTheme _pinTheme({
    required Color backgroundColor,
    required Color borderColor,
    required TextStyle textStyle,
  }) {
    return PinTheme(
      width: 64.w,
      height: 72.h,
      textStyle: textStyle,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor, width: .8.w),
      ),
    );
  }
}
