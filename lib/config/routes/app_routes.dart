import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/features/login/logic/login_cubit.dart';
import 'package:new_waqty_employee_app/features/login/ui/login_screen.dart';
import 'package:new_waqty_employee_app/features/home/logic/home_cubit.dart';
import 'package:new_waqty_employee_app/features/home/ui/home_screen.dart';
import 'package:new_waqty_employee_app/features/profile/logic/profile_cubit.dart';
import 'package:new_waqty_employee_app/features/profile/ui/profile_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // To prevent cast errors if arguments are null or not a map
    final dynamic args = settings.arguments ?? <String, dynamic>{};

    switch (settings.name) {
      // case Routes.buttonNavigationBarScreen:
      //   return MaterialPageRoute(
      //     builder: (_) => BlocProvider(
      //       create: (context) => ButtonNavigationBarCubit(),
      //       child: const ButtonNavigationBarScreen(),
      //     ),
      //   );
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => HomeCubit(getIt()),
            child: const HomeScreen(),
          ),
        );

      case Routes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => LoginCubit(getIt()),
            child: const LoginScreen(),
          ),
        );

      case Routes.profileScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ProfileCubit(getIt()),
            child: const ProfileScreen(),
          ),
        );

      default:
        return null;
    }
  }
}
