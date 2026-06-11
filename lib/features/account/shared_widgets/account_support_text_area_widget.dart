import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_card_widget.dart';

class AccountSupportTextAreaWidget extends StatelessWidget {
  final String titleKey;
  final String? subtitleKey;
  final String hintKey;
  final bool showCounter;
  final bool isOptional;
  final TextEditingController? controller;

  const AccountSupportTextAreaWidget({
    super.key,
    required this.titleKey,
    this.subtitleKey,
    required this.hintKey,
    this.showCounter = false,
    this.isOptional = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AccountSupportCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  context.tr(titleKey),
                  style: TextStyles.font14greyColor900Weight600,
                ),
              ),
              if (isOptional) ...[
                horizontalSpace(8),
                _OptionalBadge(text: context.tr('common.optional')),
              ],
            ],
          ),
          if (subtitleKey != null) ...[
            verticalSpace(4),
            Text(
              context.tr(subtitleKey!),
              style: TextStyles.font12greyColorA3W400,
            ),
          ],
          verticalSpace(12),
          _SupportTextAreaBox(
            hint: context.tr(hintKey),
            showCounter: showCounter,
            controller: controller,
          ),
        ],
      ),
    );
  }
}

class _SupportTextAreaBox extends StatelessWidget {
  final String hint;
  final bool showCounter;
  final TextEditingController? controller;

  const _SupportTextAreaBox({
    required this.hint,
    required this.showCounter,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 133.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.greyColor1001),
      ),
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: null,
              expands: true,
              maxLength: 500,
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
                isCollapsed: true,
                hintText: hint,
                hintStyle: TextStyles.font14greyColorA3W400.copyWith(
                  color: AppColors.greyColor300,
                  height: 1.45,
                ),
              ),
              style: TextStyles.font14greyColor900Weight400,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: showCounter
                    ? Text(
                        '0/500',
                        style: TextStyles.font12greyColor3003Weight400,
                      )
                    : const SizedBox.shrink(),
              ),
              Icon(
                Icons.drag_handle,
                size: 14.r,
                color: AppColors.greyColor300,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OptionalBadge extends StatelessWidget {
  final String text;

  const _OptionalBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.greyColorF5,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: Text(text, style: TextStyles.font10greyColorA3w400),
    );
  }
}
