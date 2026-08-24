import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/spacing.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/core/widgets/search_widget.dart';
import 'package:new_waqty_employee_app/features/home/search/logic/employee_search_cubit.dart';
import 'package:new_waqty_employee_app/features/home/search/logic/employee_search_state.dart';
import 'package:new_waqty_employee_app/features/home/search/ui/widgets/employee_search_results_widget.dart';

class EmployeeSearchScreen extends StatefulWidget {
  const EmployeeSearchScreen({super.key});

  @override
  State<EmployeeSearchScreen> createState() => _EmployeeSearchScreenState();
}

class _EmployeeSearchScreenState extends State<EmployeeSearchScreen> {
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoaded) return;
    _isLoaded = true;
    EmployeeSearchCubit.get(context).init(context.locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 12.h, 18.w, 10.h),
              child: Row(
                children: [
                  _BackButton(),
                  const Spacer(),
                  Text(
                    context.tr('employeeSearch.title'),
                    style: TextStyles.font18greyColor900Weight600,
                  ),
                  const Spacer(),
                  SizedBox(width: 48.r),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: SearchWidget(
                autofocus: true,
                controller: EmployeeSearchCubit.get(context).searchController,
                hintText: context.tr('employeeSearch.searchHint'),
                hintStyle: TextStyles.font14greyColor500W500,
                textStyle: TextStyles.font14greyColor900Weight500,
                backgroundColor: AppColors.greyColorFA,
                keyboardType: TextInputType.text,
                cursorColor: AppColors.greenColor500,
                onchange: EmployeeSearchCubit.get(context).search,
                validator: (value) {},
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.greyColorA3,
                  size: 22.r,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 18.w,
                  vertical: 14.h,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.greyColor1001),
                  borderRadius: BorderRadius.circular(100.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.greenColor500),
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
            ),
            verticalSpace(12),
            const _SearchTypeSelector(),
            verticalSpace(8),
            const Expanded(child: EmployeeSearchResultsWidget()),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(24.r),
      child: Container(
        height: 48.r,
        width: 48.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.whiteColor,
          border: Border.all(color: AppColors.greyColor50),
        ),
        child: Icon(Icons.arrow_back, color: AppColors.greyColor900),
      ),
    );
  }
}

class _SearchTypeSelector extends StatelessWidget {
  const _SearchTypeSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeSearchCubit, EmployeeSearchState>(
      buildWhen: (previous, current) =>
          current is EmployeeSearchTypingState ||
          current is EmployeeSearchLoadingState ||
          current is EmployeeSearchSuccessState ||
          current is EmployeeSearchErrorState,
      builder: (context, state) {
        final cubit = EmployeeSearchCubit.get(context);
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: AppColors.greyColorFA,
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Row(
              children: [
                _TypeChip(type: 'all', selectedType: cubit.selectedType),
                _TypeChip(
                  type: 'appointments',
                  selectedType: cubit.selectedType,
                ),
                _TypeChip(type: 'customers', selectedType: cubit.selectedType),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String type;
  final String selectedType;

  const _TypeChip({required this.type, required this.selectedType});

  @override
  Widget build(BuildContext context) {
    final selected = type == selectedType;
    return Expanded(
      child: InkWell(
        onTap: () => EmployeeSearchCubit.get(context).changeType(type),
        borderRadius: BorderRadius.circular(100.r),
        child: Container(
          height: 34.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.whiteColor : Colors.transparent,
            borderRadius: BorderRadius.circular(100.r),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: AppColors.greyColor900.withValues(alpha: .05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            context.tr('employeeSearch.$type'),
            style: selected
                ? TextStyles.font12greyColor900Weight600
                : TextStyles.font12greyColorA3W400,
          ),
        ),
      ),
    );
  }
}
