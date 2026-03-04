import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/app_text_field.dart';
import 'package:new_waqty_employee_app/core/widgets/button_widget.dart';
import 'package:new_waqty_employee_app/features/profile/logic/profile_cubit.dart';
import 'package:new_waqty_employee_app/features/profile/logic/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch profile data when screen loads
    ProfileCubit.get(context).getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: TextStyles.font16BlackColorWeight600.copyWith(fontSize: 20.sp),
        ),
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.blackColor14),
      ),
      body: SafeArea(
        child: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccessState) {
              AppConstant.toast(
                "Profile updated successfully",
                AppColors.greenColor,
              );
            } else if (state is UpdateProfileErrorState ||
                state is UpdateProfileCatchErrorState) {
              AppConstant.toast(
                "An error occurred while updating",
                AppColors.redColor,
              );
            } else if (state is GetProfileErrorState ||
                state is GetProfileCatchErrorState) {
              AppConstant.toast(
                "Failed to load profile data",
                AppColors.redColor,
              );
            }
          },
          builder: (context, state) {
            if (state is GetProfileLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Form(
                key: ProfileCubit.get(context).profileKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50.r,
                            backgroundColor: AppColors.greyColorDA,
                            child: Icon(
                              Icons.person,
                              size: 50.r,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 16.r,
                              backgroundColor: const Color(0xff069C54),
                              child: Icon(
                                Icons.camera_alt,
                                size: 16.r,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalSpace(32),

                    // Name Label
                    Text(
                      "Full Name",
                      style: TextStyles.font16BlackColorWeight600.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    verticalSpace(8),
                    AppTextFormField(
                      hintText: "Enter your full name",
                      hintStyle: TextStyles.font14BlackColorWeight400.copyWith(
                        color: AppColors.blackColor50,
                      ),
                      textStyle: TextStyles.font14BlackColorWeight400,
                      controller: ProfileCubit.get(context).nameController,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.greyColorDA,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.greenColor,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.redColor000,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.redColor000,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your full name";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                    ),
                    verticalSpace(20),

                    // Email Label
                    Text(
                      "Email",
                      style: TextStyles.font16BlackColorWeight600.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    verticalSpace(8),
                    AppTextFormField(
                      hintText: "Enter your email",
                      hintStyle: TextStyles.font14BlackColorWeight400.copyWith(
                        color: AppColors.blackColor50,
                      ),
                      textStyle: TextStyles.font14BlackColorWeight400,
                      controller: ProfileCubit.get(context).emailController,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.greyColorDA,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.greenColor,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.redColor000,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.redColor000,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    verticalSpace(20),

                    // Phone Label
                    Text(
                      "Phone Number",
                      style: TextStyles.font16BlackColorWeight600.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    verticalSpace(8),
                    AppTextFormField(
                      hintText: "Enter your phone number",
                      hintStyle: TextStyles.font14BlackColorWeight400.copyWith(
                        color: AppColors.blackColor50,
                      ),
                      textStyle: TextStyles.font14BlackColorWeight400,
                      controller: ProfileCubit.get(context).phoneController,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.greyColorDA,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.greenColor,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.redColor000,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.redColor000,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your phone number";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                    ),

                    verticalSpace(40),

                    ButtonWidget(
                      isLoading: state is UpdateProfileLoadingState,
                      buttonWidth: double.infinity,
                      buttonHeight: 52.h,
                      borderRadius: 12.r,
                      buttonText: "Update Profile",
                      backGroundColor: const Color(0xff069C54),
                      borderColor: Colors.transparent,
                      textStyle: TextStyles.font16WhiteColorWeight600.copyWith(
                        fontSize: 16.sp,
                      ),
                      onPressed: () {
                        ProfileCubit.get(context).updateProfile();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
