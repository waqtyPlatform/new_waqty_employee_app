import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/features/auth/login/logic/login_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/login/ui/login_screen.dart';
import 'package:new_waqty_employee_app/features/home/logic/home_cubit.dart';
import 'package:new_waqty_employee_app/features/home/ui/home_screen.dart';
import 'package:new_waqty_employee_app/features/profile/logic/profile_cubit.dart';
import 'package:new_waqty_employee_app/features/profile/ui/profile_screen.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/logic/forget_password_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/ui/forget_password_screen.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/logic/verify_code_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/ui/verify_code_screen.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/logic/reset_password_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/ui/reset_password_screen.dart';

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

      case Routes.forgetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ForgetPasswordCubit(getIt()),
            child: const ForgetPasswordScreen(),
          ),
        );

      case Routes.profileScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ProfileCubit(getIt()),
            child: const ProfileScreen(),
          ),
        );

      case Routes.verifyCodeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => VerifyCodeCubit(getIt()),
            child: const VerifyCodeScreen(),
          ),
        );

      case Routes.resetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ResetPasswordCubit(getIt()),
            child: const ResetPasswordScreen(),
          ),
        );

      default:
        return null;
    }
  }
}
