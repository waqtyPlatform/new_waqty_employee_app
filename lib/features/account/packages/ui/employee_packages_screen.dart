import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/styles.dart';
import 'package:new_waqty_employee_app/features/account/packages/logic/employee_packages_cubit.dart';
import 'package:new_waqty_employee_app/features/account/packages/ui/widgets/employee_packages_list_widget.dart';
import 'package:new_waqty_employee_app/features/account/shared_widgets/account_support_header_widget.dart';

class EmployeePackagesScreen extends StatefulWidget {
  const EmployeePackagesScreen({super.key});

  @override
  State<EmployeePackagesScreen> createState() => _EmployeePackagesScreenState();
}

class _EmployeePackagesScreenState extends State<EmployeePackagesScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      EmployeePackagesCubit.get(context).refreshPackages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            const AccountSupportHeaderWidget(
              titleKey: 'employeePackages.title',
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
              child: _PackagesSearchField(
                controller: EmployeePackagesCubit.get(context).searchController,
                onChanged: EmployeePackagesCubit.get(context).onSearchChanged,
              ),
            ),
            const Expanded(child: EmployeePackagesListWidget()),
          ],
        ),
      ),
    );
  }
}

class _PackagesSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _PackagesSearchField({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: context.tr('employeePackages.searchHint'),
        hintStyle: TextStyles.font12greyColor500W400,
        prefixIcon: Icon(
          Icons.search,
          color: AppColors.greyColor400,
          size: 20.r,
        ),
        filled: true,
        fillColor: AppColors.greyColorFA,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.greyColor50),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.greenColor500),
        ),
      ),
    );
  }
}
