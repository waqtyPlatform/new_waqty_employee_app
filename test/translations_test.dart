import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// حارس الترجمة — بيمسك التلات حالات اللي بتسيب نص إنجليزي أو مفتاح خام
/// ظاهر للمستخدم في تطبيق عربي:
///
/// 1. مفتاح موجود في لغة وناقص في التانية.
/// 2. مفتاح الكود بينده عليه ومش موجود في الـ JSON — `easy_localization`
///    بيعرض **اسم المفتاح نفسه** ساعتها، فالمستخدم بيقرا «noInternet».
/// 3. `intl.DateFormat` راجع للعرض — الأبلكيشن مافيهوش
///    `initializeDateFormatting()`، فالتواريخ إما بتطلع إنجليزي وإما
///    بترمي `LocaleDataException`. البديل `AppDateFormat`.
void main() {
  final ar = _flatten(_load('assets/languages/ar-EG.json'));
  final en = _flatten(_load('assets/languages/en-US.json'));

  test('اللغتين فيهم نفس المفاتيح بالظبط', () {
    expect(ar.keys.toSet().difference(en.keys.toSet()), isEmpty,
        reason: 'مفاتيح في ar-EG وناقصة من en-US');
    expect(en.keys.toSet().difference(ar.keys.toSet()), isEmpty,
        reason: 'مفاتيح في en-US وناقصة من ar-EG');
  });

  test('مفيش قيمة فاضية في أي لغة', () {
    for (final entry in {...ar, ...en}.entries) {
      expect(entry.value.trim(), isNotEmpty,
          reason: '${entry.key} قيمته فاضية');
    }
  });

  test('كل مفتاح نصّي الكود بينده عليه موجود في الـ JSON', () {
    final missing = <String, String>{};

    for (final file in _dartFiles()) {
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.startsWith('//') || line.startsWith('*')) continue;
        for (final match in _trCall.allMatches(line)) {
          final key = match.group(1) ?? match.group(2)!;
          // المفاتيح المركّبة بـ$ بتتحسب وقت التشغيل — مالهاش لازمة هنا
          if (key.contains(r'$')) continue;
          if (ar.containsKey(key)) continue;
          missing[key] = '${file.path}:${i + 1}';
        }
      }
    }

    expect(missing, isEmpty,
        reason: 'مفاتيح الكود بينده عليها ومش موجودة في الترجمة:\n'
            '${missing.entries.map((e) => '  ${e.key}  ←  ${e.value}').join('\n')}');
  });

  test('مفيش intl.DateFormat في كود العرض — AppDateFormat هو البديل', () {
    final offenders = <String>[];

    for (final file in _dartFiles()) {
      final path = file.path.replaceAll(r'\', '/');
      // app_constant فيه صيغ للسيرفر (yyyy-MM-dd) مالهاش أسماء أيام ولا شهور
      if (path.contains('/core/utils/app_constant.dart')) continue;
      // الـ cubits بتبعت تواريخ للـ API مش بتعرضها
      if (path.contains('/logic/')) continue;

      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.startsWith('//') || line.startsWith('///')) continue;
        if (_intlDateFormat.hasMatch(line)) {
          offenders.add('$path:${i + 1}');
        }
      }
    }

    expect(offenders, isEmpty,
        reason: 'استخدم AppDateFormat بدل intl.DateFormat في:\n'
            '${offenders.map((o) => '  $o').join('\n')}');
  });
}

/// `DateFormat(` أو `DateFormat.` — من غير ما يلزق في `AppDateFormat`.
final RegExp _intlDateFormat = RegExp(r'(?<![A-Za-z])DateFormat[(.]');

/// `context.tr('key')` · `tr('key')` · `'key'.tr()`
final RegExp _trCall = RegExp(
  r"""(?:context\.tr\(\s*|\btr\(\s*)['"]([^'"]+)['"]|['"]([^'"\s]+)['"]\s*\.tr\(""",
);

Map<String, dynamic> _load(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

Iterable<File> _dartFiles() => Directory('lib')
    .listSync(recursive: true)
    .whereType<File>()
    .where((f) => f.path.endsWith('.dart'));

Map<String, String> _flatten(Map<String, dynamic> source, [String prefix = '']) {
  final out = <String, String>{};
  source.forEach((key, value) {
    final path = prefix.isEmpty ? key : '$prefix.$key';
    if (value is Map<String, dynamic>) {
      out.addAll(_flatten(value, path));
    } else {
      out[path] = '$value';
    }
  });
  return out;
}
