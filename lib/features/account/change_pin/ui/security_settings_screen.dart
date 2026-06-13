import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/logic/app_pin_cubit.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/logic/app_pin_state.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/app_pin_header_widget.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: BlocConsumer<AppPinCubit, AppPinState>(
            listener: (context, state) {
              if (state is AppPinSuccessState) {
                AppConstant.toast(context.tr(state.messageKey), true, context);
              } else if (state is AppPinErrorState) {
                AppConstant.toast(context.tr(state.messageKey), false, context);
              }
            },
            buildWhen: (previous, current) {
              return current is AppPinLoadingState ||
                  current is AppPinStatusChangedState ||
                  current is AppPinSuccessState ||
                  current is AppPinErrorState;
            },
            builder: (context, state) {
              final cubit = AppPinCubit.get(context);

              return Column(
                children: [
                  AppPinHeaderWidget(title: context.tr('profile.changePin')),
                  verticalSpace(24),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: AppColors.greyColorFA,
                        width: .8.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.greyColor900.withValues(alpha: .04),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      children: cubit.isPinEnabled
                          ? [
                              _SecurityTileWidget(
                                title: context.tr('appPin.changeAppPin'),
                                icon: Icons.lock_reset,
                                onTap: () => context
                                    .pushNamed(Routes.changeAppPinScreen)
                                    .then((_) => cubit.loadPinStatus()),
                              ),
                              const Divider(color: AppColors.greyColorF5),
                              _SecurityTileWidget(
                                title: context.tr('appPin.disableAppPin'),
                                icon: Icons.lock_open_outlined,
                                color: AppColors.errorColor2002,
                                onTap: () => context
                                    .pushNamed(Routes.disableAppPinScreen)
                                    .then((_) => cubit.loadPinStatus()),
                              ),
                            ]
                          : [
                              _SecurityTileWidget(
                                title: context.tr('appPin.enableAppPin'),
                                icon: Icons.lock_outline,
                                onTap: () => context
                                    .pushNamed(Routes.createAppPinScreen)
                                    .then((_) => cubit.loadPinStatus()),
                              ),
                            ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SecurityTileWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _SecurityTileWidget({
    required this.title,
    required this.icon,
    required this.onTap,
    this.color = AppColors.greenColor500,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16.r,
              backgroundColor: AppColors.greyColorFA,
              child: Icon(icon, size: 18.r, color: color),
            ),
            horizontalSpace(10),
            Expanded(
              child: Text(title, style: TextStyles.font14greyColor900Weight500),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.r,
              color: AppColors.greyColorE5,
            ),
          ],
        ),
      ),
    );
  }
}
