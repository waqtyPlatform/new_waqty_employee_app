import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_waqty_employee_app/core/utils/app_date_format.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// الاختبار ده بيثبت الحاجة اللي كانت مكسورة فعلًا:
/// `intl.DateFormat('EEEE, MMMM d', 'ar')` كان بيرمي `LocaleDataException`
/// لإن `initializeDateFormatting()` مش بتتنادى في الأبلكيشن. شاشة تفاصيل
/// الحجز وديالوج الحضور كانوا بيقعوا بيها في العربي.
void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // easy_localization بيقرا اللغة المحفوظة من SharedPreferences وقت التهيئة
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  Future<String> format(
    WidgetTester tester,
    Locale locale,
    String Function(BuildContext context) build,
  ) async {
    String? result;

    final tree = EasyLocalization(
      key: UniqueKey(),
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'EG')],
      path: 'assets/languages',
      startLocale: locale,
      // ⚠ لو اتسابت `true` اللغة بتتخزّن في الـ mock وبتتسرّب للاختبار
      // اللي بعده، فالاختبار التاني بيقرا لغة الاختبار اللي فاته.
      saveLocale: false,
      fallbackLocale: const Locale('ar', 'EG'),
      child: Builder(
        builder: (context) => MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: Builder(
            builder: (inner) {
              result = build(inner);
              return Text(result!);
            },
          ),
        ),
      ),
    );

    // ⚠ `runAsync` ضروري — تحميل ملف الترجمة I/O حقيقي، و`pump` لوحده
    // بيلفّ الساعة الوهمية بس ومابيسيبش الـ Future يخلص.
    await tester.runAsync(() async {
      await tester.pumpWidget(tree);
      for (var i = 0; i < 20 && result == null; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        await tester.pump();
      }
    });

    expect(result, isNotNull, reason: 'الترجمة ما اتحمّلتش خالص');
    return result!;
  }

  final saturday = DateTime(2026, 3, 14, 15, 45);

  testWidgets('التاريخ بيطلع عربي — ومابيرميش استثناء', (tester) async {
    final text = await format(
      tester,
      const Locale('ar', 'EG'),
      (context) => AppDateFormat.dayMonth(context, saturday),
    );

    expect(text, 'السبت، 14 مارس');
  });

  testWidgets('نفس التاريخ بيطلع إنجليزي بترتيب إنجليزي', (tester) async {
    final text = await format(
      tester,
      const Locale('en', 'US'),
      (context) => AppDateFormat.dayMonth(context, saturday),
    );

    expect(text, 'Saturday, March 14');
  });

  testWidgets('الوقت بـ«م» في العربي', (tester) async {
    expect(
      await format(
        tester,
        const Locale('ar', 'EG'),
        (context) => AppDateFormat.time(context, saturday),
      ),
      '3:45 م',
    );
  });

  testWidgets('الوقت بـPM في الإنجليزي', (tester) async {
    expect(
      await format(
        tester,
        const Locale('en', 'US'),
        (context) => AppDateFormat.time(context, saturday),
      ),
      '3:45 PM',
    );
  });

  testWidgets('الشهر والسنة', (tester) async {
    expect(
      await format(
        tester,
        const Locale('ar', 'EG'),
        (context) => AppDateFormat.monthYear(context, saturday),
      ),
      'مارس 2026',
    );
  });

  testWidgets('التاريخ المختصر — اليوم قبل الشهر في العربي', (tester) async {
    expect(
      await format(
        tester,
        const Locale('ar', 'EG'),
        (context) => AppDateFormat.monthDayShort(context, saturday),
      ),
      '14 مار',
    );
  });

  testWidgets('«النهاردة»', (tester) async {
    final now = DateTime(2026, 3, 14, 9);
    expect(
      await format(
        tester,
        const Locale('ar', 'EG'),
        (context) => AppDateFormat.relativeDate(context, now, now: now),
      ),
      'النهاردة',
    );
  });

  testWidgets('«إمبارح»', (tester) async {
    final now = DateTime(2026, 3, 14, 9);
    expect(
      await format(
        tester,
        const Locale('ar', 'EG'),
        (context) => AppDateFormat.relativeDate(
          context,
          now.subtract(const Duration(days: 1)),
          now: now,
        ),
      ),
      'إمبارح',
    );
  });

  testWidgets('ترويسة النتيجة بتبدأ بالإثنين زي شبكة الحضور', (tester) async {
    final days = await format(
      tester,
      const Locale('ar', 'EG'),
      (context) => AppDateFormat.dayShorts(context).join(' '),
    );

    expect(days.split(' ').first, 'إثن');
    expect(days.split(' ').length, 7);
  });
}
