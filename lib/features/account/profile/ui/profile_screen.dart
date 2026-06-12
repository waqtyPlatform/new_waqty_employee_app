import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/assets_manager.dart';
import 'package:new_waqty_employee_app/core/utils/extentions.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/profile/logic/profile_cubit.dart';
import 'package:new_waqty_employee_app/features/account/profile/logic/profile_state.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_user_branch_widget.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_user_data_widget.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_user_log_out_widget.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_user_my_account_widget.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_user_setting_widget.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_user_work_time_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Positioned(
              top: -60.h,
              left: 0,
              right: 0,
              child: Container(
                height: 278.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.greenColor500.withValues(alpha: .1),
                      AppColors.whiteColor.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(16),
                  SafeArea(child: const _ProfileHeaderSectionWidget()),

                  verticalSpace(12),
                  const ProfileUserWorkTimeWidget(isClockedIn: true),
                  verticalSpace(20),
                  Text(
                    context.tr('profile.myAccount'),
                    style: TextStyles.font10greyColorA3W600,
                  ),
                  verticalSpace(12),
                  ProfileUserMyAccountWidget(items: _myAccountItems(context)),
                  verticalSpace(12),
                  Text(
                    context.tr('profile.branch'),
                    style: TextStyles.font10greyColorA3W600,
                  ),
                  verticalSpace(12),
                  ProfileUserBranchWidget(items: _branchItems(context)),
                  verticalSpace(12),
                  Text(
                    context.tr('profile.attendance'),
                    style: TextStyles.font10greyColorA3W600,
                  ),
                  verticalSpace(12),
                  ProfileUserBranchWidget(items: _attendanceItems(context)),
                  verticalSpace(12),
                  Text(
                    context.tr('profile.settings'),
                    style: TextStyles.font10greyColorA3W600,
                  ),
                  verticalSpace(12),
                  const ProfileUserSettingWidget(),
                  verticalSpace(12),
                  Text(
                    context.tr('profile.support'),
                    style: TextStyles.font10greyColorA3W600,
                  ),
                  verticalSpace(12),
                  ProfileUserBranchWidget(items: _supportItems(context)),
                  verticalSpace(12),
                  const ProfileUserLogOutWidget(),
                  verticalSpace(12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ProfileMenuItemData> _myAccountItems(BuildContext context) {
    return [
      ProfileMenuItemData(
        title: context.tr('profile.personalInformation'),
        iconPath: ImageAsset.profilePersonIcon,
        onTap: () => context.pushNamed(Routes.profileDetailsScreen),
      ),
      ProfileMenuItemData(
        title: context.tr('profile.myServices'),
        iconPath: ImageAsset.profileServiceIcon,
        onTap: () => context.pushNamed(Routes.myServicesScreen),
      ),
      ProfileMenuItemData(
        title: context.tr('profile.myWorkingHours'),
        iconPath: ImageAsset.profileWorkingHoursIcon,
        onTap: () => context.pushNamed(Routes.workingHoursScreen),
      ),
      ProfileMenuItemData(
        title: context.tr('profile.changePin'),
        iconPath: ImageAsset.profileChangePasswordIcon,
        onTap: () {},
      ),
      ProfileMenuItemData(
        title: context.tr('profile.biometricLogin'),
        iconPath: ImageAsset.profileBiometricIcon,
        onTap: () {},
      ),
    ];
  }

  List<ProfileMenuItemData> _branchItems(BuildContext context) {
    return [
      ProfileMenuItemData(
        title: context.tr('profile.branchContact'),
        iconPath: ImageAsset.profileBranchContactIcon,
        onTap: () => context.pushNamed(Routes.branchContactScreen),
      ),
    ];
  }

  List<ProfileMenuItemData> _attendanceItems(BuildContext context) {
    return [
      ProfileMenuItemData(
        title: context.tr('profile.attendanceHistory'),
        iconPath: ImageAsset.profileAttendanceHistoryIcon,
        onTap: () => context.pushNamed(Routes.attendanceScreen),
      ),
    ];
  }

  List<ProfileMenuItemData> _supportItems(BuildContext context) {
    return [
      ProfileMenuItemData(
        title: context.tr('profile.helpFaq'),
        iconPath: ImageAsset.helpIcon,
        onTap: () => context.pushNamed(Routes.helpQuestionsScreen),
      ),
      ProfileMenuItemData(
        title: context.tr('profile.contactManager'),
        iconPath: ImageAsset.contactManagerIcon,
        onTap: () => context.pushNamed(Routes.contactManagerScreen),
      ),
      ProfileMenuItemData(
        title: context.tr('profile.reportBug'),
        iconPath: ImageAsset.reportBugIcon,
        onTap: () => context.pushNamed(Routes.reportBugScreen),
      ),
    ];
  }
}

class _ProfileHeaderSectionWidget extends StatelessWidget {
  const _ProfileHeaderSectionWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (previous, current) {
        return current is GetProfileLoadingState ||
            current is GetProfileSuccessState ||
            current is GetProfileErrorState ||
            current is GetProfileCatchErrorState;
      },
      builder: (context, state) {
        final profile = ProfileCubit.get(context).profileResponseModel;
        if (profile == null) {
          return const ProfileUserDataWidget(
            userName: '..................',
            jobTitle: '..................',
            userCode: '..................',
            branchName: '..................',
          );
        }
        return ProfileUserDataWidget(
          userName: profile.customer.name,
          jobTitle: context.tr('profile.jobTitle'),
          userCode: context.tr('profile.employeeCode'),
          branchName: profile.customer.branchModel.name,
        );
      },
    );
  }
}
