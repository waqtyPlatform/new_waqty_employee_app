import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/features/account/attendance/logic/attendance_cubit.dart';
import 'package:new_waqty_employee_app/features/account/attendance/ui/attendance_screen.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/logic/branch_contact_cubit.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/ui/branch_contact_screen.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/logic/contact_manager_cubit.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/ui/contact_manager_screen.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/logic/help_questions_cubit.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/ui/help_questions_screen.dart';
import 'package:new_waqty_employee_app/features/account/my_services/logic/my_services_cubit.dart';
import 'package:new_waqty_employee_app/features/account/my_services/ui/my_services_screen.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/logic/notification_setting_cubit.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/ui/notification_setting_screen.dart';
import 'package:new_waqty_employee_app/features/account/profile_details/logic/profile_details_cubit.dart';
import 'package:new_waqty_employee_app/features/account/profile_details/ui/profile_details_screen.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/logic/report_bug_cubit.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/ui/report_bug_screen.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/logic/working_hours_cubit.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/ui/working_hours_screen.dart';
import 'package:new_waqty_employee_app/features/auth/login/logic/login_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/login/ui/login_screen.dart';
import 'package:new_waqty_employee_app/features/home/logic/home_cubit.dart';
import 'package:new_waqty_employee_app/features/home/ui/home_screen.dart';
import 'package:new_waqty_employee_app/features/account/profile/logic/profile_cubit.dart';
import 'package:new_waqty_employee_app/features/account/profile/ui/profile_screen.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/logic/forget_password_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/ui/forget_password_screen.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/logic/verify_code_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/ui/verify_code_screen.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/logic/reset_password_cubit.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/ui/reset_password_screen.dart';
import 'package:new_waqty_employee_app/features/main_navigation/ui/screens/main_navigation_screen.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/logic/booking_details_cubit.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/booking_details_screen.dart';

class RouteGenerator {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    // To prevent cast errors if arguments are null or not a map
    final dynamic args = settings.arguments ?? <String, dynamic>{};

    switch (settings.name) {
      case Routes.mainNavigationScreen:
        return MaterialPageRoute(builder: (_) => const MainNavigationScreen());
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
            create: (context) => ProfileCubit(getIt())..init(),
            child: const ProfileScreen(),
          ),
        );

      case Routes.verifyCodeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => VerifyCodeCubit(getIt(), getIt()),
            child: VerifyCodeScreen(email: args['email']),
          ),
        );

      case Routes.resetPasswordScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ResetPasswordCubit(getIt()),
            child: ResetPasswordScreen(
              email: args['email'],
              code: args['code'],
            ),
          ),
        );

      case Routes.bookingDetailsScreen:
        final uuid = args is Map ? args['uuid']?.toString() ?? '' : '';
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
                BookingDetailsCubit(getIt())..getBookingDetails(uuid),
            child: const BookingDetailsScreen(),
          ),
        );

      case Routes.myServicesScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => MyServicesCubit(getIt()),
            child: const MyServicesScreen(),
          ),
        );

      case Routes.profileDetailsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ProfileDetailsCubit(getIt())..getProfile(),
            child: const ProfileDetailsScreen(),
          ),
        );

      case Routes.workingHoursScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => WorkingHoursCubit(getIt()),
            child: const WorkingHoursScreen(),
          ),
        );

      case Routes.attendanceScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AttendanceCubit(),
            child: const AttendanceScreen(),
          ),
        );

      case Routes.branchContactScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) =>
                BranchContactCubit(getIt())
                  ..getBranchContact(context.locale.languageCode),
            child: const BranchContactScreen(),
          ),
        );

      case Routes.helpQuestionsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => HelpQuestionsCubit(getIt()),
            child: const HelpQuestionsScreen(),
          ),
        );

      case Routes.contactManagerScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ContactManagerCubit(getIt()),
            child: const ContactManagerScreen(),
          ),
        );

      case Routes.reportBugScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ReportBugCubit(getIt()),
            child: const ReportBugScreen(),
          ),
        );

      case Routes.notificationSettingScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) =>
                NotificationSettingCubit(getIt())
                  ..getNotificationSettings(context.locale.languageCode),
            child: const NotificationSettingScreen(),
          ),
        );

      default:
        return null;
    }
  }
}
