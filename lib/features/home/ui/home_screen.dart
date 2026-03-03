import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/features/home/logic/home_cubit.dart';
import 'package:new_waqty_employee_app/features/home/logic/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // Listen to state changes here
        },
        builder: (context, state) {
          return const Center(child: Text("Welcome to Home Screen!"));
        },
      ),
    );
  }
}
