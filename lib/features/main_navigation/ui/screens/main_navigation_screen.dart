import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/features/home/logic/home_cubit.dart';
import 'package:new_waqty_employee_app/features/home/ui/home_screen.dart';
import 'package:new_waqty_employee_app/features/main_navigation/cubit/main_navigation_cubit.dart';
import 'package:new_waqty_employee_app/features/main_navigation/cubit/main_navigation_state.dart';
import 'package:new_waqty_employee_app/features/main_navigation/ui/widgets/custom_bottom_nav_bar.dart';
import '../../../../core/utils/app_colors_white_theme.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainNavigationCubit(),
      child: const MainNavigationScreenView(),
    );
  }
}

class MainNavigationScreenView extends StatelessWidget {
  const MainNavigationScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainNavigationCubit, MainNavigationState>(
      buildWhen: (previous, current) {
        return current is MainNavigationTabChanged;
      },
      builder: (context, state) {
        return SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: AppColors.whiteColor,
            body: _buildBody(MainNavigationCubit.get(context).currentIndex),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: MainNavigationCubit.get(context).currentIndex,
              onTap: (index) {
                MainNavigationCubit.get(context).changeTab(index);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return BlocProvider(
          create: (context) => HomeCubit(getIt()),
          child: const HomeScreen(),
        );
      case 1:
        return const Center(child: Text('Booking Screen'));
      case 2:
        return const Center(child: Text('Stats Screen'));
      case 3:
        return const Center(child: Text('Money Screen'));
      case 4:
        return const Center(child: Text('Account Screen'));
      default:
        return const Center(child: Text('Home Screen'));
    }
  }
}
