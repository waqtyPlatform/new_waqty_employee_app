import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/working_hours_cubit.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/ui/widgets/working_hours_content_widget.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/ui/widgets/working_hours_header_widget.dart';

class WorkingHoursScreen extends StatefulWidget {
  const WorkingHoursScreen({super.key});

  @override
  State<WorkingHoursScreen> createState() => _WorkingHoursScreenState();
}

class _WorkingHoursScreenState extends State<WorkingHoursScreen> {
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    WorkingHoursCubit.get(
      context,
    ).scrollListenerMyWorkingHoursScrollController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      final cubit = WorkingHoursCubit.get(context);
      cubit.clearGetAllWorkingHours();
      cubit.getWorkingHours(languageCode: context.locale.languageCode);
    }
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
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          child: Column(
            children: [
              const WorkingHoursHeaderWidget(),
              verticalSpace(16),
              const Expanded(child: WorkingHoursContentWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
