import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/assets_manager.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/app_text_field.dart';
import 'package:new_waqty_employee_app/core/widgets/button_widget.dart';
import 'package:new_waqty_employee_app/features/account/profile/logic/profile_cubit.dart';
import 'package:new_waqty_employee_app/features/account/profile/logic/profile_state.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_user_branch_widget.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_user_data_widget.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_user_log_out_widget.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_user_my_account_widget.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_user_setting_widget.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/widgets/profile_user_work_time_widget.dart';

class MyServicesScreen extends StatelessWidget {
  const MyServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalSpace(16),
              ProfileUserDataWidget(
                userName: 'Ahmed Hassan Mohamed',
                jobTitle: 'Senior Stylist',
                userCode: 'EMP-0042',
                branchName: 'Cairo Downtown Branch',
              ),
              verticalSpace(12),
              ProfileUserWorkTimeWidget(
                type: 'Clock Out',
                time: 'Clocked in at 9:02 AM · 8h 12m',
              ),
              verticalSpace(28),
              Text('MY ACCOUNT', style: TextStyles.font10greyColorA3W600),
              verticalSpace(12),
              ProfileUserMyAccountWidget(
                items: [
                  ProfileMenuItemData(
                    title: 'Personal Information',
                    iconPath: ImageAsset.profilePersonIcon,
                    onTap: () {},
                  ),
                  ProfileMenuItemData(
                    title: 'My Services',
                    iconPath: ImageAsset.profileServiceIcon,
                    onTap: () {},
                  ),
                  ProfileMenuItemData(
                    title: 'My Working Hours',
                    iconPath: ImageAsset.profileWorkingHoursIcon,
                    onTap: () {},
                  ),
                  ProfileMenuItemData(
                    title: 'Change PIN',
                    iconPath: ImageAsset.profileChangePasswordIcon,
                    onTap: () {},
                  ),
                  ProfileMenuItemData(
                    title: 'Biometric Login',
                    iconPath: ImageAsset.profileBiometricIcon,
                    onTap: () {},
                  ),
                ],
              ),
              verticalSpace(12),
              Text('BRANCH', style: TextStyles.font10greyColorA3W600),
              verticalSpace(12),
              ProfileUserBranchWidget(
                items: [
                  ProfileMenuItemData(
                    title: 'Branch Contact',
                    iconPath: ImageAsset.profileBranchContactIcon,
                    onTap: () {},
                  ),
                ],
              ),
              verticalSpace(12),
              Text('ATTENDANCE', style: TextStyles.font10greyColorA3W600),
              verticalSpace(12),
              ProfileUserBranchWidget(
                items: [
                  ProfileMenuItemData(
                    title: 'Attendance History',
                    iconPath: ImageAsset.profileAttendanceHistoryIcon,
                    onTap: () {},
                  ),
                ],
              ),

              //
              verticalSpace(12),
              Text('SETTINGS', style: TextStyles.font10greyColorA3W600),
              verticalSpace(12),
              ProfileUserSettingWidget(),

              verticalSpace(12),
              Text('SUPPORT', style: TextStyles.font10greyColorA3W600),
              verticalSpace(12),
              ProfileUserBranchWidget(
                items: [
                  ProfileMenuItemData(
                    title: 'Help & FAQ',
                    iconPath: ImageAsset.helpIcon,
                    onTap: () {},
                  ),
                  ProfileMenuItemData(
                    title: 'Contact Manager',
                    iconPath: ImageAsset.contactManagerIcon,
                    onTap: () {},
                  ),
                  ProfileMenuItemData(
                    title: 'Report a Bug',
                    iconPath: ImageAsset.reportBugIcon,
                    onTap: () {},
                  ),
                ],
              ),
              verticalSpace(12),
              ProfileUserLogOutWidget(),
              verticalSpace(12),
            ],
          ),
        ),
      ),
    );
  }
}
