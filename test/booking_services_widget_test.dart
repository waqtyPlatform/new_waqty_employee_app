import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/data/models/booking_details_response_model.dart';
import 'package:new_waqty_employee_app/features/booking/booking_details/ui/widgets/booking_services_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  Future<void> pumpServices(
    WidgetTester tester,
    List<BookingServiceLine> services,
  ) async {
    final tree = EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'EG')],
      path: 'assets/languages',
      startLocale: const Locale('en', 'US'),
      saveLocale: false,
      fallbackLocale: const Locale('en', 'US'),
      child: Builder(
        builder: (context) => ScreenUtilInit(
          designSize: const Size(375, 812),
          child: MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: Scaffold(
              body: SingleChildScrollView(
                child: BookingServicesWidget(
                  services: services,
                  onAddTap: null,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.runAsync(() async {
      await tester.pumpWidget(tree);
      await Future<void>.delayed(const Duration(milliseconds: 60));
      await tester.pumpAndSettle();
    });
  }

  testWidgets('groups single visit package by instance and orders items', (
    tester,
  ) async {
    final services = [
      _line(
        itemUuid: 'package-2',
        name: 'Second Package Service',
        sourceType: 'single_visit_package',
        package: const PackageMeta(
          instanceId: 'instance-a',
          name: 'Dental Package',
          itemPosition: 2,
        ),
      ),
      _line(
        itemUuid: 'package-1',
        name: 'First Package Service',
        sourceType: 'single_visit_package',
        package: const PackageMeta(
          instanceId: 'instance-a',
          name: 'Dental Package',
          itemPosition: 1,
        ),
      ),
    ];

    await pumpServices(tester, services);

    expect(find.text('Visit packages'), findsNothing);
    expect(find.text('Dental Package'), findsOneWidget);
    expect(find.text('Services'), findsNWidgets(2));
    expect(find.text('First Package Service'), findsOneWidget);
    expect(find.text('Second Package Service'), findsOneWidget);

    final firstTop = tester.getTopLeft(find.text('First Package Service')).dy;
    final secondTop = tester.getTopLeft(find.text('Second Package Service')).dy;
    expect(firstTop, lessThan(secondTop));
  });

  testWidgets('renders mixed source sections without duplicate package items', (
    tester,
  ) async {
    final services = [
      _line(itemUuid: 'normal', name: 'Normal Service'),
      _line(
        itemUuid: 'package-1',
        name: 'Package Service A',
        sourceType: 'single_visit_package',
        package: const PackageMeta(
          instanceId: 'instance-a',
          name: 'Dental Package',
          itemPosition: 1,
        ),
      ),
      _line(
        itemUuid: 'package-2',
        name: 'Package Service B',
        sourceType: 'single_visit_package',
        package: const PackageMeta(
          instanceId: 'instance-a',
          name: 'Dental Package',
          itemPosition: 2,
        ),
      ),
      _line(
        itemUuid: 'session',
        name: 'Laser Session',
        sourceType: 'multi_session',
        package: const PackageMeta(
          name: 'Laser Package',
          sessionNumber: 3,
          sessions: PackageSessionsMeta(
            total: 10,
            reserved: 0,
            used: 3,
            completed: 3,
            available: 7,
            remaining: 7,
          ),
        ),
      ),
      _line(
        itemUuid: 'usage',
        name: 'Usage Service',
        sourceType: 'usage_based',
        usagePackage: const UsagePackageMeta(
          name: 'Pulse Package',
          availableUnits: 700,
          unitName: 'pulse',
          selectedService: PackageServiceMeta(
            name: 'Usage Service',
            durationMinutes: 30,
          ),
        ),
      ),
      _line(
        itemUuid: 'follow',
        name: 'Follow Service',
        sourceType: 'follow_up',
        followUp: const FollowUpMeta(
          originalService: 'Original Cleaning',
          originalEmployee: 'Ahmed',
        ),
      ),
    ];

    await pumpServices(tester, services);

    expect(find.text('Normal services'), findsOneWidget);
    expect(find.text('Visit packages'), findsOneWidget);
    expect(find.text('Package sessions'), findsOneWidget);
    expect(find.text('Usage packages'), findsOneWidget);
    expect(find.text('Follow-ups'), findsOneWidget);
    expect(find.text('Package Service A'), findsOneWidget);
    expect(find.text('Package Service B'), findsOneWidget);
    expect(find.text('Session 3 of 10'), findsOneWidget);
    expect(find.text('7 sessions remaining'), findsOneWidget);
    expect(find.text('Available balance: 700 pulse'), findsOneWidget);
    expect(find.text('Original service: Original Cleaning'), findsOneWidget);
    expect(find.text('Original employee: Ahmed'), findsOneWidget);
  });
}

BookingServiceLine _line({
  required String itemUuid,
  required String name,
  String sourceType = 'normal_service',
  PackageMeta? package,
  UsagePackageMeta? usagePackage,
  FollowUpMeta? followUp,
}) {
  return BookingServiceLine(
    itemUuid: itemUuid,
    serviceUuid: null,
    name: name,
    category: null,
    price: '0',
    currency: 'EGP',
    durationMinutes: 30,
    isAdded: false,
    status: 'confirmed',
    sourceType: sourceType,
    coveredByPackage: sourceType != 'normal_service',
    package: package,
    usagePackage: usagePackage,
    followUp: followUp,
  );
}
