import 'package:new_waqty_employee_app/config/routes/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:new_waqty_employee_app/core/services/services_locator.dart';
import 'package:new_waqty_employee_app/features/account/biometric/ui/biometric_lock_screen.dart';
import 'package:new_waqty_employee_app/features/account/biometric/ui/biometric_settings_screen.dart';
import 'package:new_waqty_employee_app/features/account/biometric/ui/disable_biometric_screen.dart';
import 'package:new_waqty_employee_app/features/account/biometric/ui/enable_biometric_screen.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/data/services/app_pin_service.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/logic/app_pin_cubit.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/change_app_pin_screen.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/create_pin_screen.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/disable_app_pin_screen.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/enter_pin_screen.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/security_settings_screen.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/splash_screen.dart';
import 'package:new_waqty_employee_app/features/account/attendance/logic/attendance_cubit.dart';
import 'package:new_waqty_employee_app/features/account/attendance/ui/attendance_screen.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/logic/branch_contact_cubit.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/ui/branch_contact_screen.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/change_pin_screen.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/ui/widgets/change_pin_step_data.dart';
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
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.mainNavigationScreen:
        final isPinVerified = args is Map && args['pinVerified'] == true;
        final isSecurityVerified =
            args is Map && args['securityVerified'] == true;
        return MaterialPageRoute(
          builder: (_) => _MainNavigationGate(
            isPinVerified: isPinVerified,
            isSecurityVerified: isSecurityVerified,
          ),
        );
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

      case Routes.changePinCurrentScreen:
        return MaterialPageRoute(
          builder: (_) => const ChangePinScreen(step: ChangePinStep.currentPin),
        );

      case Routes.changePinNewScreen:
        return MaterialPageRoute(
          builder: (_) => const ChangePinScreen(step: ChangePinStep.newPin),
        );

      case Routes.changePinConfirmScreen:
        return MaterialPageRoute(
          builder: (_) => const ChangePinScreen(step: ChangePinStep.confirmPin),
        );

      case Routes.securitySettingsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                AppPinCubit(getIt(), getIt())..loadSecuritySettings(),
            child: const SecuritySettingsScreen(),
          ),
        );

      case Routes.enterAppPinScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppPinCubit(getIt(), getIt()),
            child: const EnterPinScreen(),
          ),
        );

      case Routes.createAppPinScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppPinCubit(getIt(), getIt()),
            child: const CreatePinScreen(),
          ),
        );

      case Routes.changeAppPinScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppPinCubit(getIt(), getIt()),
            child: const ChangeAppPinScreen(),
          ),
        );

      case Routes.disableAppPinScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppPinCubit(getIt(), getIt()),
            child: const DisableAppPinScreen(),
          ),
        );

      case Routes.biometricSettingsScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                AppPinCubit(getIt(), getIt())..loadSecuritySettings(),
            child: const BiometricSettingsScreen(),
          ),
        );

      case Routes.biometricLockScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppPinCubit(getIt(), getIt()),
            child: const BiometricLockScreen(),
          ),
        );

      case Routes.enableBiometricScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AppPinCubit(getIt(), getIt()),
            child: const EnableBiometricScreen(),
          ),
        );

      case Routes.disableBiometricScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                AppPinCubit(getIt(), getIt())..loadSecuritySettings(),
            child: const DisableBiometricScreen(),
          ),
        );

      default:
        return null;
    }
  }
}

class _MainNavigationGate extends StatefulWidget {
  final bool isPinVerified;
  final bool isSecurityVerified;

  const _MainNavigationGate({
    required this.isPinVerified,
    required this.isSecurityVerified,
  });

  @override
  State<_MainNavigationGate> createState() => _MainNavigationGateState();
}

class _MainNavigationGateState extends State<_MainNavigationGate> {
  AppLockDestination? _destination;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDestination();
  }

  Future<void> _loadDestination() async {
    final destination = await getIt<AppPinService>().decideAppLockDestination();
    if (!mounted) return;
    setState(() {
      _destination = destination;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const _RouteLoadingScreen();

    final destination = _destination ?? AppLockDestination.login;
    if (destination == AppLockDestination.login) {
      return BlocProvider(
        create: (context) => LoginCubit(getIt()),
        child: const LoginScreen(),
      );
    }

    final isVerified = widget.isSecurityVerified || widget.isPinVerified;
    if (destination == AppLockDestination.biometric && !isVerified) {
      return BlocProvider(
        create: (_) => AppPinCubit(getIt(), getIt()),
        child: const BiometricLockScreen(),
      );
    }

    if (destination == AppLockDestination.pin && !isVerified) {
      return BlocProvider(
        create: (_) => AppPinCubit(getIt(), getIt()),
        child: const EnterPinScreen(),
      );
    }

    return const MainNavigationScreen();
  }
}

class _RouteLoadingScreen extends StatelessWidget {
  const _RouteLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
