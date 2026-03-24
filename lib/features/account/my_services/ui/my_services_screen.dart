import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';

import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/my_services/logic/my_services_cubit.dart';
import 'package:new_waqty_employee_app/features/account/my_services/logic/my_services_state.dart';

import 'package:new_waqty_employee_app/features/account/my_services/ui/widgets/profile_service_items_widget.dart';
import 'package:new_waqty_employee_app/features/account/my_services/ui/widgets/my_services_shimmer_loading.dart';

class MyServicesScreen extends StatefulWidget {
  const MyServicesScreen({super.key});

  @override
  State<MyServicesScreen> createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  @override
  void initState() {
    super.initState();
    MyServicesCubit.get(context).clearGetAllServices();
    MyServicesCubit.get(context).getAllServices();
    MyServicesCubit.get(context).scrollListenerMyServicesScrollController();
  }

  @override
  void dispose() {
    MyServicesCubit.get(context).myServicesScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              /// HEADER
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
                    'My Services',
                    style: TextStyles.font18greyColor900Weight600,
                  ),
                  const Spacer(flex: 2),
                ],
              ),

              verticalSpace(16),

              /// LIST
              Container(
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.greyColorFA,
                    width: 0.8.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.greyColor900.withOpacity(0.04),
                      blurRadius: 4,
                      spreadRadius: 0,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: BlocBuilder<MyServicesCubit, MyServicesState>(
                  buildWhen: (previous, current) =>
                      current is OnGetAllServicesLoadingState ||
                      current is OnGetAllServicesSuccessState ||
                      current is GetMyServicesErrorState ||
                      current is GetMyServicesCatchErrorState,
                  builder: (context, state) {
                    /// Loading أول مرة
                    if (MyServicesCubit.get(context).myServices.isEmpty &&
                        state is OnGetAllServicesLoadingState) {
                      return const MyServicesShimmerLoading();
                    } else if (MyServicesCubit.get(
                      context,
                    ).myServices.isEmpty) {
                      return   Center(child: Text('No Services Found',style: TextStyles.font16greyColor900Weight400));
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        controller: MyServicesCubit.get(
                          context,
                        ).myServicesScrollController,
                        itemCount:
                            MyServicesCubit.get(context).myServices.length +
                            1,
                        itemBuilder: (context, index) {
                          /// Items
                          if (index <
                              MyServicesCubit.get(
                                context,
                              ).myServices.length) {
                            return ProfileServiceItemsWidget(
                              items: [
                                MyServicesCubit.get(
                                  context,
                                ).myServices[index],
                              ],
                            );
                          }

                          /// Loader تحت
                          return MyServicesCubit.get(
                                    context,
                                  ).myServicesCurrentPage <
                                  MyServicesCubit.get(
                                    context,
                                  ).myServicesLastPage
                              ? Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.greenColor500,
                                    ),
                                  ),
                                )
                              : const SizedBox();
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
