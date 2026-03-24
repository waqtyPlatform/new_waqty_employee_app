import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/my_services/ui/widgets/my_services_shimmer_loading.dart';
import 'package:new_waqty_employee_app/features/account/profile_details/logic/profile_details_cubit.dart';
import 'package:new_waqty_employee_app/features/account/profile_details/logic/profile_details_state.dart';
import 'package:new_waqty_employee_app/features/account/profile_details/ui/widgets/user_data_widget.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 48.r,
                    width: 48.r,
                    margin: EdgeInsets.symmetric(horizontal: 2.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.whiteColor,
                      border: Border.all(color: AppColors.greyColor50),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.greyColor900,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Personal Information',
                    style: TextStyles.font18greyColor900Weight600,
                  ),
                  const Spacer(flex: 2),
                ],
              ),

              verticalSpace(16),
              Expanded(
                child: BlocBuilder<ProfileDetailsCubit, ProfileDetailsState>(
                  buildWhen: (previous, current) {
                    return current is GetProfileLoadingState ||
                        current is GetProfileSuccessState ||
                        current is GetProfileErrorState ||
                        current is GetProfileCatchErrorState;
                  },
                  builder: (context, state) {
                    if (ProfileDetailsCubit.get(context).profileResponseModel ==
                        null) {
                      return const MyServicesShimmerLoading();
                    } else {
                      return UserDataWidget(
                        item: ProfileDetailsCubit.get(
                          context,
                        ).profileResponseModel!.customer,
                      );
                    }
                  },
                ),
              ),
              verticalSpace(12),
            ],
          ),
        ),
      ),
    );
  }
}
