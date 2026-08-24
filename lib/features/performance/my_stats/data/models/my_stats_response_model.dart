class MyStatsResponseModel {
  final bool success;
  final MyStatsDataModel data;

  const MyStatsResponseModel({required this.success, required this.data});

  factory MyStatsResponseModel.fromJson(Map<String, dynamic> json) {
    return MyStatsResponseModel(
      success: _asBool(json['success'], fallback: true),
      data: MyStatsDataModel.fromJson(_asMap(json['data'])),
    );
  }
}

class MyStatsDataModel {
  final MyStatsPeriodModel period;
  final MyStatsKpisModel kpis;
  final List<MyStatsAppointmentsSeriesModel> appointmentsSeries;
  final List<MyStatsRevenueSeriesModel> revenueSeries;
  final List<MyStatsServiceModel> services;
  final MyStatsReviewsSummaryModel reviewsSummary;
  final MyStatsComparisonModel comparison;
  final MyStatsDataQualityModel dataQuality;

  const MyStatsDataModel({
    required this.period,
    required this.kpis,
    required this.appointmentsSeries,
    required this.revenueSeries,
    required this.services,
    required this.reviewsSummary,
    required this.comparison,
    required this.dataQuality,
  });

  factory MyStatsDataModel.fromJson(Map<String, dynamic> json) {
    final kpisJson = _asMap(json['kpis']);
    final kpis = MyStatsKpisModel.fromJson(kpisJson);

    return MyStatsDataModel(
      period: MyStatsPeriodModel.fromJson(_asMap(json['period'])),
      kpis: kpis,
      appointmentsSeries: _asList(
        json['appointments_series'],
      ).map(MyStatsAppointmentsSeriesModel.fromJson).toList(),
      revenueSeries: _asList(
        json['revenue_series'],
      ).map(MyStatsRevenueSeriesModel.fromJson).toList(),
      services: _asList(
        json['services'],
      ).map(MyStatsServiceModel.fromJson).toList(),
      reviewsSummary: MyStatsReviewsSummaryModel.fromJson(
        _asMap(json['reviews_summary']),
      ),
      comparison: MyStatsComparisonModel.fromJson(
        _asMap(json['comparison']),
        kpis: kpisJson,
      ),
      dataQuality: MyStatsDataQualityModel.fromJson(
        _asMap(json['data_quality']),
      ),
    );
  }
}

class MyStatsPeriodModel {
  final String value;
  final String label;
  final String startDate;
  final String endDate;

  const MyStatsPeriodModel({
    required this.value,
    required this.label,
    required this.startDate,
    required this.endDate,
  });

  factory MyStatsPeriodModel.fromJson(Map<String, dynamic> json) {
    return MyStatsPeriodModel(
      value: _asString(json['type'] ?? json['value']),
      label: _asString(json['label']),
      startDate: _asString(json['start_at'] ?? json['start_date']),
      endDate: _asString(json['end_at'] ?? json['end_date']),
    );
  }
}

class MyStatsKpisModel {
  final MyStatsAppointmentsKpiModel appointments;
  final MyStatsRevenueKpiModel revenue;
  final MyStatsRatingKpiModel rating;
  final MyStatsUtilizationKpiModel utilization;

  const MyStatsKpisModel({
    required this.appointments,
    required this.revenue,
    required this.rating,
    required this.utilization,
  });

  factory MyStatsKpisModel.fromJson(Map<String, dynamic> json) {
    return MyStatsKpisModel(
      appointments: MyStatsAppointmentsKpiModel.fromJson(
        _asMap(json['appointments']),
      ),
      revenue: MyStatsRevenueKpiModel.fromJson(_asMap(json['revenue'])),
      rating: MyStatsRatingKpiModel.fromJson(_asMap(json['rating'])),
      utilization: MyStatsUtilizationKpiModel.fromJson(
        _asMap(json['utilization']),
      ),
    );
  }
}

class MyStatsAppointmentsKpiModel {
  final int current;
  final double? percentageChange;

  const MyStatsAppointmentsKpiModel({
    required this.current,
    required this.percentageChange,
  });

  factory MyStatsAppointmentsKpiModel.fromJson(Map<String, dynamic> json) {
    return MyStatsAppointmentsKpiModel(
      current: _asInt(json['current']),
      percentageChange: _asNullableDouble(json['percentage_change']),
    );
  }
}

class MyStatsRevenueKpiModel {
  final String current;
  final String currency;
  final bool mixedCurrency;
  final double? percentageChange;
  final List<MyStatsCurrencyAmountModel> currencies;

  const MyStatsRevenueKpiModel({
    required this.current,
    required this.currency,
    required this.mixedCurrency,
    required this.percentageChange,
    required this.currencies,
  });

  factory MyStatsRevenueKpiModel.fromJson(Map<String, dynamic> json) {
    final rawCurrencies = _asList(json['currencies']);
    final currencies = rawCurrencies
        .map(MyStatsCurrencyAmountModel.fromJson)
        .toList();
    final primary = rawCurrencies.isEmpty
        ? const <String, dynamic>{}
        : rawCurrencies.first;

    return MyStatsRevenueKpiModel(
      current: _asString(
        json['current'] ?? json['value'] ?? primary['current'],
        fallback: '0',
      ),
      currency: _asString(json['currency'] ?? primary['currency']),
      mixedCurrency: _asBool(json['mixed_currency']),
      percentageChange: _asNullableDouble(
        json['percentage_change'] ?? primary['percentage_change'],
      ),
      currencies: currencies,
    );
  }

  String get displayValue {
    if (mixedCurrency && currencies.isNotEmpty) {
      return currencies.map((item) => item.displayValue).join(' / ');
    }
    return currency.isEmpty ? _money(current) : '$currency ${_money(current)}';
  }
}

class MyStatsCurrencyAmountModel {
  final String currency;
  final String value;

  const MyStatsCurrencyAmountModel({
    required this.currency,
    required this.value,
  });

  factory MyStatsCurrencyAmountModel.fromJson(Map<String, dynamic> json) {
    return MyStatsCurrencyAmountModel(
      currency: _asString(json['currency']),
      value: _asString(
        json['current'] ?? json['value'] ?? json['amount'],
        fallback: '0',
      ),
    );
  }

  String get displayValue =>
      currency.isEmpty ? _money(value) : '$currency ${_money(value)}';
}

class MyStatsRatingKpiModel {
  final double currentAverage;
  final int currentCount;
  final double? percentageChange;

  const MyStatsRatingKpiModel({
    required this.currentAverage,
    required this.currentCount,
    required this.percentageChange,
  });

  factory MyStatsRatingKpiModel.fromJson(Map<String, dynamic> json) {
    return MyStatsRatingKpiModel(
      currentAverage: _asDouble(json['current_average']),
      currentCount: _asInt(json['current_count']),
      percentageChange: _asNullableDouble(json['percentage_change']),
    );
  }

  String get displayAverage {
    if (currentCount == 0) return '0';
    if (currentAverage == currentAverage.roundToDouble()) {
      return currentAverage.toStringAsFixed(0);
    }
    return currentAverage.toStringAsFixed(1);
  }
}

class MyStatsUtilizationKpiModel {
  final double percentage;
  final int occupiedMinutes;
  final int availableMinutes;
  final double? percentageChange;

  const MyStatsUtilizationKpiModel({
    required this.percentage,
    required this.occupiedMinutes,
    required this.availableMinutes,
    required this.percentageChange,
  });

  factory MyStatsUtilizationKpiModel.fromJson(Map<String, dynamic> json) {
    return MyStatsUtilizationKpiModel(
      percentage: _asDouble(json['percentage']),
      occupiedMinutes: _asInt(json['occupied_minutes']),
      availableMinutes: _asInt(json['available_minutes']),
      percentageChange: _asNullableDouble(json['percentage_change']),
    );
  }
}

class MyStatsAppointmentsSeriesModel {
  final String date;
  final String label;
  final int appointmentsCount;

  const MyStatsAppointmentsSeriesModel({
    required this.date,
    required this.label,
    required this.appointmentsCount,
  });

  factory MyStatsAppointmentsSeriesModel.fromJson(Map<String, dynamic> json) {
    return MyStatsAppointmentsSeriesModel(
      date: _asString(json['date']),
      label: _asString(json['label']),
      appointmentsCount: _asInt(json['appointments_count']),
    );
  }
}

class MyStatsRevenueSeriesModel {
  final String date;
  final String label;
  final String value;
  final String currency;

  const MyStatsRevenueSeriesModel({
    required this.date,
    required this.label,
    required this.value,
    required this.currency,
  });

  factory MyStatsRevenueSeriesModel.fromJson(Map<String, dynamic> json) {
    return MyStatsRevenueSeriesModel(
      date: _asString(json['date']),
      label: _asString(json['label'] ?? json['date']),
      value: _asString(json['value'], fallback: '0'),
      currency: _asString(json['currency']),
    );
  }

  double get numericValue => _asDouble(value);
}

class MyStatsServiceModel {
  final String serviceName;
  final int completedItemsCount;
  final String attributedServiceValue;
  final String currency;
  final double sharePercentage;

  const MyStatsServiceModel({
    required this.serviceName,
    required this.completedItemsCount,
    required this.attributedServiceValue,
    required this.currency,
    required this.sharePercentage,
  });

  factory MyStatsServiceModel.fromJson(Map<String, dynamic> json) {
    return MyStatsServiceModel(
      serviceName: _asString(json['service_name']),
      completedItemsCount: _asInt(json['completed_items_count']),
      attributedServiceValue: _asString(
        json['attributed_service_value'],
        fallback: '0',
      ),
      currency: _asString(json['currency']),
      sharePercentage: _asDouble(json['share_percentage']),
    );
  }

  String get valueLabel => currency.isEmpty
      ? _money(attributedServiceValue)
      : '$currency ${_money(attributedServiceValue)}';
}

class MyStatsReviewsSummaryModel {
  final double average;
  final int total;
  final Map<int, int> distribution;

  const MyStatsReviewsSummaryModel({
    required this.average,
    required this.total,
    required this.distribution,
  });

  factory MyStatsReviewsSummaryModel.fromJson(Map<String, dynamic> json) {
    final rawDistribution = _asMap(json['distribution']);
    return MyStatsReviewsSummaryModel(
      average: _asDouble(json['average']),
      total: _asInt(json['total']),
      distribution: rawDistribution.map(
        (key, value) => MapEntry(int.tryParse(key) ?? 0, _asInt(value)),
      )..removeWhere((key, value) => key == 0),
    );
  }

  String get displayAverage {
    if (total == 0) return '0';
    if (average == average.roundToDouble()) return average.toStringAsFixed(0);
    return average.toStringAsFixed(1);
  }
}

class MyStatsComparisonModel {
  final MyStatsComparisonRowModel appointments;
  final List<MyStatsComparisonRowModel> revenues;
  final MyStatsComparisonRowModel rating;

  const MyStatsComparisonModel({
    required this.appointments,
    required this.revenues,
    required this.rating,
  });

  factory MyStatsComparisonModel.fromJson(
    Map<String, dynamic> json, {
    Map<String, dynamic>? kpis,
  }) {
    final appointmentsKpi = _asMap(kpis?['appointments']);
    final ratingKpi = _asMap(kpis?['rating']);
    final revenueKpi = _asMap(kpis?['revenue']);
    var revenueRows = _asList(revenueKpi['currencies']);
    if (revenueRows.isEmpty) {
      revenueRows = _asList(json['revenue']);
    }
    if (revenueRows.isEmpty && _asMap(json['revenue']).isNotEmpty) {
      revenueRows = [_asMap(json['revenue'])];
    }

    return MyStatsComparisonModel(
      appointments: MyStatsComparisonRowModel.fromPerformanceKpi(
        appointmentsKpi.isEmpty
            ? _asMap(json['appointments'])
            : appointmentsKpi,
      ),
      revenues: revenueRows
          .map(MyStatsComparisonRowModel.fromPerformanceKpi)
          .toList(),
      rating: MyStatsComparisonRowModel.fromPerformanceKpi(
        ratingKpi.isEmpty ? _asMap(json['rating']) : ratingKpi,
      ),
    );
  }
}

class MyStatsComparisonRowModel {
  final String current;
  final String last;
  final String best;
  final String currency;

  const MyStatsComparisonRowModel({
    required this.current,
    required this.last,
    required this.best,
    required this.currency,
  });

  factory MyStatsComparisonRowModel.fromJson(Map<String, dynamic> json) {
    return MyStatsComparisonRowModel(
      current: _asString(json['current']),
      last: _asString(json['last']),
      best: _asString(json['best']),
      currency: _asString(json['currency']),
    );
  }

  factory MyStatsComparisonRowModel.fromPerformanceKpi(
    Map<String, dynamic> json,
  ) {
    final best = json['best'];
    final bestValue = best is Map ? best['value'] : best;

    return MyStatsComparisonRowModel(
      current: _asString(json['current'] ?? json['current_average']),
      last: _asString(
        json['previous'] ?? json['previous_average'] ?? json['last'],
      ),
      best: _asString(bestValue),
      currency: _asString(json['currency']),
    );
  }
}

class MyStatsDataQualityModel {
  final bool hasEstimatedUtilization;

  const MyStatsDataQualityModel({required this.hasEstimatedUtilization});

  factory MyStatsDataQualityModel.fromJson(Map<String, dynamic> json) {
    return MyStatsDataQualityModel(
      hasEstimatedUtilization: _asBool(json['has_estimated_utilization']),
    );
  }
}

String _money(String value) {
  final parsed = double.tryParse(value);
  if (parsed == null) return value;
  final normalized = parsed == parsed.roundToDouble()
      ? parsed.toStringAsFixed(0)
      : parsed.toStringAsFixed(2);
  return normalized.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(\.|$))'),
    (match) => '${match[1]},',
  );
}

List<Map<String, dynamic>> _asList(dynamic value) {
  return (value is List ? value : const [])
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

double _asDouble(dynamic value, {double fallback = 0}) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? fallback;
}

double? _asNullableDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

String _asString(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  final text = value.toString().trim();
  if (text.isEmpty || text.toLowerCase() == 'null') return fallback;
  return text;
}

bool _asBool(dynamic value, {bool fallback = false}) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value?.toString().toLowerCase().trim();
  if (text == 'true' || text == '1' || text == 'yes') return true;
  if (text == 'false' || text == '0' || text == 'no') return false;
  return fallback;
}
