import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

/// تنسيق التواريخ والأوقات المعروضة — **البديل الوحيد لـ`intl` في العرض**.
///
/// ## ⚠ ليه مش `intl.DateFormat`
///
/// الأبلكيشن **ماعندهوش `initializeDateFormatting()`**، وده بيسيب `intl`
/// في حالتين وحشين مافيش تالت:
///
/// | الاستخدام | اللي بيحصل فعليًا |
/// |---|---|
/// | `DateFormat('EEEE, MMMM d', 'ar')` | **بيرمي `LocaleDataException`** — الشاشة بتقع |
/// | `DateFormat('EEEE, MMMM d')` | بيرجع `Saturday, March 14` **إنجليزي** في تطبيق عربي |
///
/// فالأسماء هنا بتيجي من `assets/languages/*.json` تحت `date.*` زيها زي
/// أي نص تاني — بتتبدّل مع اللغة من غير ما حاجة تتهيّأ ومن غير ما حاجة تتنسى.
///
/// ## ⚠ ترتيب الكلام في الـ JSON مش في الكود
///
/// العربي بيقول «السبت، 14 مارس» والإنجليزي بيقول «Saturday, March 14» —
/// **الترتيب نفسه مختلف**, مش الأسماء بس. عشان كده الصيغ قاعدة في
/// `date.patterns.*` بـ`namedArgs`، فأي لغة تتضاف بتظبط ترتيبها لوحدها
/// من غير `if (languageCode == 'ar')` متزرّع في الكود.
///
/// الأرقام بتفضل **غربية `1234`** زي ما هي — ده قرار السوق المصري.
class AppDateFormat {
  AppDateFormat._();

  /// Parses API timestamps using the Cairo wall-clock sent by the backend.
  /// This keeps the app on Egypt time even when the device uses another zone.
  static DateTime? parseBackendDateTime(String value) {
    final normalized = value.trim();
    final wallClock = RegExp(
      r'^\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}(?::\d{2}(?:\.\d+)?)?',
    ).firstMatch(normalized)?.group(0);

    return DateTime.tryParse(wallClock ?? normalized);
  }

  /// مفهرسة بـ `weekday - 1` — الاتنين أول يوم في `DateTime`.
  static const List<String> _dayKeys = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  /// مفهرسة بـ `month - 1`.
  static const List<String> _monthKeys = [
    'january',
    'february',
    'march',
    'april',
    'may',
    'june',
    'july',
    'august',
    'september',
    'october',
    'november',
    'december',
  ];

  static String dayName(BuildContext context, DateTime value) =>
      context.tr('date.days.${_dayKeys[value.weekday - 1]}');

  static String dayShort(BuildContext context, DateTime value) =>
      context.tr('date.daysShort.${_dayKeys[value.weekday - 1]}');

  /// أسماء الأيام المختصرة بالترتيب لترويسة نتيجة — بادئة بـ[startWeekday].
  ///
  /// ⚠ **لازم تبدأ بنفس اليوم اللي شبكة النتيجة بتبدأ بيه**، وإلا الترويسة
  /// هتقول يوم والخانة تحتيها تبقى يوم تاني.
  static List<String> dayShorts(
    BuildContext context, {
    int startWeekday = DateTime.monday,
  }) => List.generate(
    7,
    (index) => context.tr(
      'date.daysShort.${_dayKeys[(startWeekday - 1 + index) % 7]}',
    ),
  );

  static String monthName(BuildContext context, DateTime value) =>
      context.tr('date.months.${_monthKeys[value.month - 1]}');

  static String monthShort(BuildContext context, DateTime value) =>
      context.tr('date.monthsShort.${_monthKeys[value.month - 1]}');

  /// `السبت، 14 مارس` · `Saturday, March 14`
  static String dayMonth(BuildContext context, DateTime value) => context.tr(
    'date.patterns.dayMonth',
    namedArgs: {
      'day': dayName(context, value),
      'dayNum': '${value.day}',
      'month': monthName(context, value),
    },
  );

  /// `14 مار` · `Mar 14`
  static String monthDayShort(BuildContext context, DateTime value) =>
      context.tr(
        'date.patterns.monthDayShort',
        namedArgs: {
          'dayNum': '${value.day}',
          'month': monthShort(context, value),
        },
      );

  /// `مارس 2026` · `March 2026`
  static String monthYear(BuildContext context, DateTime value) => context.tr(
    'date.patterns.monthYear',
    namedArgs: {'month': monthName(context, value), 'year': '${value.year}'},
  );

  /// `14 مارس 2026` · `March 14, 2026`
  static String fullDate(BuildContext context, DateTime value) => context.tr(
    'date.patterns.fullDate',
    namedArgs: {
      'dayNum': '${value.day}',
      'month': monthName(context, value),
      'year': '${value.year}',
    },
  );

  /// `3:45 م` · `3:45 PM`
  static String time(BuildContext context, DateTime value) => context.tr(
    'date.patterns.time',
    namedArgs: {
      'hour': '${_hour12(value.hour)}',
      'minute': _two(value.minute),
      'marker': _marker(context, value.hour),
    },
  );

  /// `3:45:20 م` · `3:45:20 PM`
  static String timeWithSeconds(BuildContext context, DateTime value) =>
      context.tr(
        'date.patterns.timeSeconds',
        namedArgs: {
          'hour': '${_hour12(value.hour)}',
          'minute': _two(value.minute),
          'second': _two(value.second),
          'marker': _marker(context, value.hour),
        },
      );

  /// `3:45 م - 4:30 م`
  static String timeRange(BuildContext context, DateTime start, DateTime end) =>
      context.tr(
        'date.patterns.timeRange',
        namedArgs: {'start': time(context, start), 'end': time(context, end)},
      );

  /// `السبت، 14 مارس • 3:45 م`
  static String dayMonthTime(BuildContext context, DateTime value) =>
      context.tr(
        'date.patterns.dateTime',
        namedArgs: {
          'date': dayMonth(context, value),
          'time': time(context, value),
        },
      );

  /// «النهاردة» · «إمبارح» · «بكرة» — وإلا [fullDate].
  static String relativeDate(
    BuildContext context,
    DateTime value, {
    DateTime? now,
  }) {
    final today = _dateOnly(now ?? DateTime.now());
    final diff = _dateOnly(value).difference(today).inDays;

    return switch (diff) {
      0 => context.tr('date.today'),
      1 => context.tr('date.tomorrow'),
      -1 => context.tr('date.yesterday'),
      _ => fullDate(context, value),
    };
  }

  /// `"14:30"` جاي من الباك إند ← `3:45 م`.
  ///
  /// بيرجّع النص زي ما هو لو مش على الصيغة المتوقعة — الشاشة تعرض قيمة
  /// وحشة أحسن ما ترمي استثناء.
  static String timeOfDay(BuildContext context, String value) {
    final parts = value.split(':');
    if (parts.length < 2) return value;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return value;

    return context.tr(
      'date.patterns.time',
      namedArgs: {
        'hour': '${_hour12(hour)}',
        'minute': _two(minute),
        'marker': _marker(context, hour),
      },
    );
  }

  static int _hour12(int hour24) => hour24 % 12 == 0 ? 12 : hour24 % 12;

  static String _marker(BuildContext context, int hour24) =>
      context.tr(hour24 < 12 ? 'date.am' : 'date.pm');

  static String _two(int value) => value.toString().padLeft(2, '0');

  static DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}
