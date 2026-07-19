import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:device_info_plus/device_info_plus.dart';

import 'package:get_it/get_it.dart';
import 'package:new_waqty_employee_app/core/utils/app_colors_white_theme.dart';
import 'package:new_waqty_employee_app/core/utils/app_constant.dart';
import 'package:new_waqty_employee_app/features/account/biometric/data/services/biometric_auth_service.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/data/services/app_pin_service.dart';
import 'package:new_waqty_employee_app/features/account/attendance/data/repo/attendance_repo.dart';
import 'package:new_waqty_employee_app/features/account/attendance/data/services/attendance_service.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/data/repo/branch_contact_repo.dart';
import 'package:new_waqty_employee_app/features/account/branch_contact/data/services/branch_contact_service.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/data/repo/contact_manager_repo.dart';
import 'package:new_waqty_employee_app/features/account/contact_manager/data/services/contact_manager_service.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/data/repo/help_questions_repo.dart';
import 'package:new_waqty_employee_app/features/account/help_questions/data/services/help_questions_service.dart';
import 'package:new_waqty_employee_app/features/account/my_services/data/repo/my_services_repo.dart';
import 'package:new_waqty_employee_app/features/account/my_services/data/services/my_services_service.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/data/repo/notification_setting_repo.dart';
import 'package:new_waqty_employee_app/features/account/notification_setting/data/services/notification_setting_service.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/data/repo/report_bug_repo.dart';
import 'package:new_waqty_employee_app/features/account/report_bug/data/services/report_bug_service.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/repo/working_hours_repo.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/services/working_hours_service.dart';

import '../api/api_consumer.dart';
import '../api/app_interceptor.dart';
import '../api/http_consumer.dart';

import 'package:new_waqty_employee_app/features/auth/login/data/repo/login_repo.dart';
import 'package:new_waqty_employee_app/features/auth/login/data/services/login_service.dart';

import 'package:new_waqty_employee_app/features/home/data/repo/home_repo.dart';
import 'package:new_waqty_employee_app/features/home/data/services/home_service.dart';

import 'package:new_waqty_employee_app/features/account/profile/data/repo/profile_repo.dart';
import 'package:new_waqty_employee_app/features/account/profile/data/services/profile_service.dart';

import 'package:new_waqty_employee_app/features/auth/forget_password/data/repo/forget_password_repo.dart';
import 'package:new_waqty_employee_app/features/auth/forget_password/data/services/forget_password_service.dart';

import 'package:new_waqty_employee_app/features/auth/verify_code/data/repo/verify_code_repo.dart';
import 'package:new_waqty_employee_app/features/auth/verify_code/data/services/verify_code_service.dart';

import 'package:new_waqty_employee_app/features/auth/reset_password/data/repo/reset_password_repo.dart';
import 'package:new_waqty_employee_app/features/auth/reset_password/data/services/reset_password_service.dart';

import 'package:new_waqty_employee_app/features/booking/my_booking/data/repo/my_booking_repo.dart';
import 'package:new_waqty_employee_app/features/booking/my_booking/data/services/my_booking_service.dart';

import 'package:new_waqty_employee_app/features/booking/booking_details/data/repo/booking_details_repo.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/services/booking_details_service.dart';

import 'package:new_waqty_employee_app/features/performance/my_stats/data/repo/my_stats_repo.dart';
import 'package:new_waqty_employee_app/features/performance/my_stats/data/services/my_stats_service.dart';

final getIt = GetIt.instance;

class ServicesLocator {
  static Future<void> init() async {
    /// Home
    getIt.registerLazySingleton<HomeService>(
      () => HomeService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<HomeRepo>(() => HomeRepo(getIt()));

    ///constant
    // getIt.registerLazySingleton<EndPoints>(() => EndPoints());
    getIt.registerLazySingleton<AppConstant>(() => AppConstant());
    getIt.registerLazySingleton<AppColors>(() => AppColors());

    ///core

    getIt.registerLazySingleton<AppInterceptor>(() => AppInterceptor());

    getIt.registerLazySingleton<ApiConsumer>(() => HttpConsumer(getIt()));
    getIt.registerLazySingleton(() => http.Client());

    ///shared secure
    FlutterSecureStorage secureStorage = FlutterSecureStorage();
    getIt.registerLazySingleton(() => secureStorage);
    getIt.registerLazySingleton<LocalAuthentication>(
      () => LocalAuthentication(),
    );
    getIt.registerLazySingleton<DeviceInfoPlugin>(() => DeviceInfoPlugin());
    getIt.registerLazySingleton<AppPinService>(() => AppPinService(getIt()));
    getIt.registerLazySingleton<BiometricAuthService>(
      () => BiometricAuthService(getIt(), getIt()),
    );

    /// Login
    getIt.registerLazySingleton<LoginService>(
      () => LoginService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<LoginRepo>(() => LoginRepo(getIt()));

    /// Profile
    getIt.registerLazySingleton<ProfileService>(
      () => ProfileService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<ProfileRepo>(() => ProfileRepo(getIt()));

    /// Forget Password
    getIt.registerLazySingleton<ForgetPasswordService>(
      () => ForgetPasswordService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<ForgetPasswordRepo>(
      () => ForgetPasswordRepo(getIt()),
    );

    /// Verify Code
    getIt.registerLazySingleton<VerifyCodeService>(
      () => VerifyCodeService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<VerifyCodeRepo>(() => VerifyCodeRepo(getIt()));

    /// Reset Password
    getIt.registerLazySingleton<ResetPasswordService>(
      () => ResetPasswordService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<ResetPasswordRepo>(
      () => ResetPasswordRepo(getIt()),
    );

    /// My Booking
    getIt.registerLazySingleton<MyBookingService>(
      () => MyBookingService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<MyBookingRepo>(() => MyBookingRepo(getIt()));

    /// Booking Details
    getIt.registerLazySingleton<BookingDetailsService>(
      () => BookingDetailsService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<BookingDetailsRepo>(
      () => BookingDetailsRepo(getIt()),
    );

    /// My Stats
    getIt.registerLazySingleton<MyStatsService>(
      () => MyStatsService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<MyStatsRepo>(() => MyStatsRepo(getIt()));

    /// My Services
    getIt.registerLazySingleton<MyServicesService>(
      () => MyServicesService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<MyServicesRepo>(() => MyServicesRepo(getIt()));

    /// Working Hours
    getIt.registerLazySingleton<WorkingHoursService>(
      () => WorkingHoursService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<WorkingHoursRepo>(
      () => WorkingHoursRepo(getIt()),
    );

    /// Attendance
    getIt.registerLazySingleton<AttendanceService>(
      () => AttendanceService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<AttendanceRepo>(() => AttendanceRepo(getIt()));

    /// Branch Contact
    getIt.registerLazySingleton<BranchContactService>(
      () => BranchContactService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<BranchContactRepo>(
      () => BranchContactRepo(getIt()),
    );

    /// Help Questions
    getIt.registerLazySingleton<HelpQuestionsService>(
      () => HelpQuestionsService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<HelpQuestionsRepo>(
      () => HelpQuestionsRepo(getIt()),
    );

    /// Contact Manager
    getIt.registerLazySingleton<ContactManagerService>(
      () => ContactManagerService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<ContactManagerRepo>(
      () => ContactManagerRepo(getIt()),
    );

    /// Report Bug
    getIt.registerLazySingleton<ReportBugService>(
      () => ReportBugService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<ReportBugRepo>(() => ReportBugRepo(getIt()));

    /// Notification Setting
    getIt.registerLazySingleton<NotificationSettingService>(
      () => NotificationSettingService(apiConsumer: getIt()),
    );
    getIt.registerLazySingleton<NotificationSettingRepo>(
      () => NotificationSettingRepo(getIt()),
    );
  }
}
