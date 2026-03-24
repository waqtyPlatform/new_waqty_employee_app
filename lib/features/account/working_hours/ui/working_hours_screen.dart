import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/my_services/ui/widgets/my_services_shimmer_loading.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/working_hours_cubit.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/working_hours_state.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/ui/widgets/profile_working_hours_items_widget.dart';

class WorkingHoursScreen extends StatefulWidget {
  const WorkingHoursScreen({super.key});

  @override
  State<WorkingHoursScreen> createState() => _WorkingHoursScreenState();
}
class _WorkingHoursScreenState extends State<WorkingHoursScreen> {
  @override
  void initState() {
    super.initState();
    WorkingHoursCubit.get(context).clearGetAllWorkingHours();
    WorkingHoursCubit.get(context).getWorkingHours();
    WorkingHoursCubit.get(context).scrollListenerMyWorkingHoursScrollController();
  }

  @override
  void dispose() {
    WorkingHoursCubit.get(context).myWorkingHoursScrollController.dispose();
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
                    'Working Hours',
                    style: TextStyles.font18greyColor900Weight600,
                  ),
                  const Spacer(flex: 2),
                ],
              ),

              verticalSpace(16),

              /// LIST
              Expanded(
                child: Container(
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
                  child: BlocBuilder<WorkingHoursCubit, WorkingHoursState>(
                    buildWhen: (previous, current) =>
                    current is  GetWorkingHoursLoadingState ||
                        current is GetWorkingHoursSuccessState ||
                        current is  GetWorkingHoursErrorState ||
                        current is  GetWorkingHoursCatchErrorState,
                    builder: (context, state) {
                      /// Loading أول مرة
                      if (WorkingHoursCubit.get(context).myWorkingHours.isEmpty &&
                          state is GetWorkingHoursLoadingState) {
                        return const MyServicesShimmerLoading();
                      } else if (WorkingHoursCubit.get(
                        context,
                      ).myWorkingHours.isEmpty) {
                        return   Center(child: Text('No Working Hours Found',style: TextStyles.font16greyColor900Weight400));
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            controller: WorkingHoursCubit.get(
                              context,
                            ).myWorkingHoursScrollController,
                            itemCount:
                            WorkingHoursCubit.get(context).myWorkingHours.length +
                                1,
                            itemBuilder: (context, index) {
                              /// Items
                              if (index <
                                  WorkingHoursCubit.get(
                                    context,
                                  ).myWorkingHours.length) {
                                return ProfileWorkingHoursItemsWidget(
                                  items:
                                    WorkingHoursCubit.get(
                                      context,
                                    ).myWorkingHours[index],

                                );
                              }

                              /// Loader تحت
                              return WorkingHoursCubit.get(
                                context,
                              ).myWorkingHoursCurrentPage <
                                  WorkingHoursCubit.get(
                                    context,
                                  ).myWorkingHoursLastPage
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
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

