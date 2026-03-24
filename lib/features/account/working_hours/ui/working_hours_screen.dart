import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/working_hours_cubit.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/working_hours_state.dart';

class WorkingHoursScreen extends StatefulWidget {
  const WorkingHoursScreen({super.key});

  @override
  State<WorkingHoursScreen> createState() => _WorkingHoursScreenState();
}

class _WorkingHoursScreenState extends State<WorkingHoursScreen> {
  @override
  void initState() {
    super.initState();
    WorkingHoursCubit.get(context).getWorkingHours();
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
                      child: const Icon(
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
              Expanded(
                child: BlocBuilder<WorkingHoursCubit, WorkingHoursState>(
                  builder: (context, state) {
                    if (state is GetWorkingHoursLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetWorkingHoursErrorState) {
                      return Center(child: Text(state.message));
                    } else if (state is GetWorkingHoursSuccessState) {
                      return const Center(child: Text('Working Hours Data Loaded'));
                    }
                    return const SizedBox();
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
