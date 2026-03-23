import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';

import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/my_services/logic/my_services_cubit.dart';
import 'package:new_waqty_employee_app/features/account/my_services/logic/my_services_state.dart';

import 'package:new_waqty_employee_app/features/account/my_services/ui/widgets/profile_service_items_widget.dart';

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
                  Spacer(flex: 1),
                  Text(
                    'My Services',
                    style: TextStyles.font18greyColor900Weight600,
                  ),
                  Spacer(flex: 2),
                ],
              ),

              verticalSpace(16),
              BlocBuilder<MyServicesCubit, MyServicesState>(
                buildWhen: (previous, current) {
                  return current is GetAllServicesLoadingState ||
                      current is GetAllServicesSuccessState ||
                      current is GetAllServicesErrorState ||
                      current is GetMyServicesCatchErrorState;
                },
                builder: (context, state) {
                  if (MyServicesCubit.get(context).myServices.isEmpty &&
                      state is GetAllServicesLoadingState) {
                    //loading
                    return Center(child: CircularProgressIndicator());
                  } else if (MyServicesCubit.get(context).myServices.isEmpty &&
                      state is! GetAllServicesLoadingState) {
                    //error
                    return Center(child: Text('empty'));
                  } else {
                    //success
                    return ProfileServiceItemsWidget(
                      items: MyServicesCubit.get(context).myServices,
                    );
                  }
                },
              ),

              //
              verticalSpace(12),
            ],
          ),
        ),
      ),
    );
  }
}
