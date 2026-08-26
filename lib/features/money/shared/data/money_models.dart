class EmployeeMoneyPreviewModel {
  final String state;
  final String month;
  final String currency;
  final double salary;
  final double commission;
  final double pendingCommission;
  final double bonus;
  final double actualDeduction;
  final double suggestedDeduction;
  final double netPay;
  final double serviceValueGenerated;
  final MoneyAttendanceSummary attendance;
  final MoneyPayslipSummary? latestPayslip;
  final MoneyCommissionTarget? commissionTarget;

  const EmployeeMoneyPreviewModel({
    required this.state,
    required this.month,
    required this.currency,
    required this.salary,
    required this.commission,
    required this.pendingCommission,
    required this.bonus,
    required this.actualDeduction,
    required this.suggestedDeduction,
    required this.netPay,
    required this.serviceValueGenerated,
    required this.attendance,
    required this.latestPayslip,
    required this.commissionTarget,
  });

  factory EmployeeMoneyPreviewModel.fromJson(Map<String, dynamic> json) {
    final data = _data(json);
    final salary = _mapAny(data, const ['salary', 'basic_salary', 'payroll']);
    final commission = _mapAny(data, const [
      'commission',
      'commission_summary',
    ]);
    final bonus = _mapAny(data, const ['bonus', 'bonuses']);
    final deduction = _mapAny(data, const ['deduction', 'deductions']);
    final net = _mapAny(data, const ['net_pay', 'net', 'pay']);

    return EmployeeMoneyPreviewModel(
      state: _str(data['state'] ?? data['pay_state'] ?? data['status']),
      month: _str(_value(data['month']) ?? data['month']),
      currency: _currency(data),
      salary: _num(
        data['basic_salary'] ?? salary['basic_salary'] ?? salary['amount'],
      ),
      commission: _num(
        data['net_earned_commission'] ??
            data['commission_earned'] ??
            commission['net_earned'] ??
            commission['earned'] ??
            commission['amount'],
      ),
      pendingCommission: _num(
        data['pending_commission'] ??
            commission['pending'] ??
            commission['pending_commission'],
      ),
      bonus: _num(
        data['bonus'] ??
            data['bonuses_total'] ??
            bonus['total'] ??
            bonus['amount'],
      ),
      actualDeduction: _num(
        data['actual_deduction'] ??
            deduction['actual'] ??
            deduction['total'] ??
            deduction['amount'],
      ),
      suggestedDeduction: _num(
        data['suggested_deduction'] ??
            deduction['suggested'] ??
            deduction['estimated'] ??
            deduction['estimated_amount'],
      ),
      netPay: _num(
        data['net_pay'] ??
            data['estimated_net_pay'] ??
            data['final_net_pay'] ??
            data['paid_net_pay'] ??
            net['amount'],
      ),
      serviceValueGenerated: _num(
        data['service_value_generated'] ??
            data['attributed_service_value'] ??
            commission['service_value_generated'],
      ),
      attendance: MoneyAttendanceSummary.fromJson(
        _mapAny(data, const ['attendance_summary', 'attendance']),
      ),
      latestPayslip: _nullableMap(data['latest_payslip']) == null
          ? null
          : MoneyPayslipSummary.fromJson(_map(data['latest_payslip'])),
      commissionTarget: _nullableMap(data['commission_target']) == null
          ? null
          : MoneyCommissionTarget.fromJson(_map(data['commission_target'])),
    );
  }

  String get payTitleKey => switch (state) {
    'final' => 'myEarning.finalNetPay',
    'paid' => 'myEarning.paidNetPay',
    _ => 'myEarning.estimatedNetPay',
  };

  String get payStatusKey => switch (state) {
    'final' => 'myEarning.finalLabel',
    'paid' => 'myEarning.paid',
    _ => 'myEarning.estimatedLabel',
  };

  double get shownDeduction => state == 'estimated' && actualDeduction == 0
      ? suggestedDeduction
      : actualDeduction;

  String money(double value, {bool plus = false, bool minus = false}) =>
      formatMoney(value, currency, plus: plus, minus: minus);
}

class MoneyAttendanceSummary {
  final int scheduledWorkDays;
  final int presentDays;
  final int absentDays;
  final int paidLeaveDays;
  final int unpaidLeaveDays;
  final int halfDays;
  final int lateInstances;
  final int earlyLeaveInstances;

  const MoneyAttendanceSummary({
    required this.scheduledWorkDays,
    required this.presentDays,
    required this.absentDays,
    required this.paidLeaveDays,
    required this.unpaidLeaveDays,
    required this.halfDays,
    required this.lateInstances,
    required this.earlyLeaveInstances,
  });

  factory MoneyAttendanceSummary.fromJson(Map<String, dynamic> json) {
    return MoneyAttendanceSummary(
      scheduledWorkDays: _int(json['scheduled_work_days']),
      presentDays: _int(json['present_days']),
      absentDays: _int(json['absent_days']),
      paidLeaveDays: _int(json['paid_leave_days']),
      unpaidLeaveDays: _int(json['unpaid_leave_days']),
      halfDays: _int(json['half_days']),
      lateInstances: _int(json['late_instances']),
      earlyLeaveInstances: _int(json['early_leave_instances']),
    );
  }
}

class MoneyCommissionTarget {
  final double current;
  final double target;
  final double expectedCommission;
  final String currency;

  const MoneyCommissionTarget({
    required this.current,
    required this.target,
    required this.expectedCommission,
    required this.currency,
  });

  factory MoneyCommissionTarget.fromJson(Map<String, dynamic> json) {
    return MoneyCommissionTarget(
      current: _num(json['current'] ?? json['service_value_generated']),
      target: _num(json['target'] ?? json['target_amount']),
      expectedCommission: _num(
        json['expected_commission'] ?? json['estimated_commission'],
      ),
      currency: _str(json['currency']),
    );
  }

  double get progress => target <= 0 ? 0 : (current / target).clamp(0, 1);
}

class MoneyTrendModel {
  final String period;
  final String month;
  final String currency;
  final List<MoneyTrendBucket> buckets;
  final MoneyTrendSummary summary;

  const MoneyTrendModel({
    required this.period,
    required this.month,
    required this.currency,
    required this.buckets,
    required this.summary,
  });

  factory MoneyTrendModel.fromJson(Map<String, dynamic> json) {
    final data = _data(json);
    final currency = _currency(data);
    final buckets = _list(data['buckets'] ?? data['trend'] ?? data['items'])
        .map(
          (item) => MoneyTrendBucket.fromJsonWithFallback(
            item,
            fallbackCurrency: currency,
          ),
        )
        .toList();
    return MoneyTrendModel(
      period: _str(data['period']),
      month: _str(_value(data['month']) ?? data['month']),
      currency: currency,
      buckets: buckets,
      summary: MoneyTrendSummary.fromJson(
        _map(data['summary']),
        buckets: buckets,
        currency: currency,
      ),
    );
  }
}

class MoneyTrendSummary {
  final double total;
  final double avgDay;
  final double bestDay;
  final String currency;

  const MoneyTrendSummary({
    required this.total,
    required this.avgDay,
    required this.bestDay,
    required this.currency,
  });

  factory MoneyTrendSummary.fromJson(
    Map<String, dynamic> json, {
    required List<MoneyTrendBucket> buckets,
    required String currency,
  }) {
    final total = _num(json['total'] ?? json['net_earnings']);
    final avg = _num(json['avg_day'] ?? json['average'] ?? json['avg']);
    final best = _num(json['best_day'] ?? json['best']);
    return MoneyTrendSummary(
      total: total == 0
          ? buckets.fold<double>(0, (sum, item) => sum + item.netEarnings)
          : total,
      avgDay: avg,
      bestDay: best,
      currency: _str(json['currency'], fallback: currency),
    );
  }
}

class MoneyTrendBucket {
  final String date;
  final String weekStart;
  final String weekEnd;
  final String label;
  final int appointmentsCount;
  final int servicesCount;
  final double serviceValueGenerated;
  final double commissionEarned;
  final double bonus;
  final double deduction;
  final double netEarnings;
  final String currency;

  const MoneyTrendBucket({
    required this.date,
    required this.weekStart,
    required this.weekEnd,
    required this.label,
    required this.appointmentsCount,
    required this.servicesCount,
    required this.serviceValueGenerated,
    required this.commissionEarned,
    required this.bonus,
    required this.deduction,
    required this.netEarnings,
    required this.currency,
  });

  factory MoneyTrendBucket.fromJson(Map<String, dynamic> json) {
    return MoneyTrendBucket.fromJsonWithFallback(json);
  }

  factory MoneyTrendBucket.fromJsonWithFallback(
    Map<String, dynamic> json, {
    String fallbackCurrency = '',
  }) {
    final currency = _currency(json);
    return MoneyTrendBucket(
      date: _str(json['date']),
      weekStart: _str(json['week_start']),
      weekEnd: _str(json['week_end']),
      label: _str(json['label']),
      appointmentsCount: _int(json['appointments_count']),
      servicesCount: _int(json['services_count']),
      serviceValueGenerated: _num(json['service_value_generated']),
      commissionEarned: _num(json['commission_earned']),
      bonus: _num(json['bonus']),
      deduction: _num(json['deduction']),
      netEarnings: _num(json['net_earnings']),
      currency: currency.isNotEmpty ? currency : fallbackCurrency,
    );
  }
}

class DailyMoneyDetailModel {
  final String date;
  final int appointmentsCount;
  final int servicesCount;
  final double serviceValueGenerated;
  final double commissionEarned;
  final double bonus;
  final double deduction;
  final double netEarnings;
  final String currency;
  final List<DailyServiceMoneyItem> services;

  const DailyMoneyDetailModel({
    required this.date,
    required this.appointmentsCount,
    required this.servicesCount,
    required this.serviceValueGenerated,
    required this.commissionEarned,
    required this.bonus,
    required this.deduction,
    required this.netEarnings,
    required this.currency,
    required this.services,
  });

  factory DailyMoneyDetailModel.fromJson(Map<String, dynamic> json) {
    final data = _data(json);
    final currency = _currency(data);
    return DailyMoneyDetailModel(
      date: _str(data['date']),
      appointmentsCount: _int(data['appointments_count']),
      servicesCount: _int(data['services_count']),
      serviceValueGenerated: _num(data['service_value_generated']),
      commissionEarned: _num(data['commission_earned']),
      bonus: _num(data['bonus']),
      deduction: _num(data['deduction']),
      netEarnings: _num(data['net_earnings']),
      currency: currency,
      services: _list(data['services'])
          .map(
            (item) => DailyServiceMoneyItem.fromJsonWithFallback(
              item,
              fallbackCurrency: currency,
            ),
          )
          .toList(),
    );
  }
}

class DailyServiceMoneyItem {
  final String serviceName;
  final String customerName;
  final String completedAt;
  final double serviceValueGenerated;
  final double commissionAmount;
  final String commissionStatus;
  final String currency;
  final String sourceType;

  const DailyServiceMoneyItem({
    required this.serviceName,
    required this.customerName,
    required this.completedAt,
    required this.serviceValueGenerated,
    required this.commissionAmount,
    required this.commissionStatus,
    required this.currency,
    required this.sourceType,
  });

  factory DailyServiceMoneyItem.fromJson(Map<String, dynamic> json) {
    return DailyServiceMoneyItem.fromJsonWithFallback(json);
  }

  factory DailyServiceMoneyItem.fromJsonWithFallback(
    Map<String, dynamic> json, {
    String fallbackCurrency = '',
  }) {
    final customer = _map(json['customer']);
    final currency = _currency(json);
    return DailyServiceMoneyItem(
      serviceName: _str(json['service_name'] ?? json['name']),
      customerName: _str(json['customer_name'] ?? customer['name']),
      completedAt: _str(json['completed_at']),
      serviceValueGenerated: _num(json['service_value_generated']),
      commissionAmount: _num(
        json['commission_amount'] ?? json['commission_earned'],
      ),
      commissionStatus: _str(json['commission_status'] ?? json['status']),
      currency: currency.isNotEmpty ? currency : fallbackCurrency,
      sourceType: _str(json['source_type']),
    );
  }
}

class MoneyPayslipsResponse {
  final List<MoneyPayslipSummary> items;
  final int currentPage;
  final int lastPage;

  const MoneyPayslipsResponse({
    required this.items,
    required this.currentPage,
    required this.lastPage,
  });

  factory MoneyPayslipsResponse.fromJson(Map<String, dynamic> json) {
    final data = _data(json);
    final items = _list(
      data['items'] ?? data['payslips'] ?? json['data'],
    ).map(MoneyPayslipSummary.fromJson).toList();
    final pagination = _map(
      data['pagination'] ?? _map(json['meta'])['pagination'] ?? json['meta'],
    );
    return MoneyPayslipsResponse(
      items: items,
      currentPage: _int(pagination['current_page'], fallback: 1),
      lastPage: _int(pagination['last_page'], fallback: 1),
    );
  }
}

class MoneyPayslipSummary {
  final String uuid;
  final String month;
  final String label;
  final String status;
  final double netPay;
  final String currency;

  const MoneyPayslipSummary({
    required this.uuid,
    required this.month,
    required this.label,
    required this.status,
    required this.netPay,
    required this.currency,
  });

  factory MoneyPayslipSummary.fromJson(Map<String, dynamic> json) {
    return MoneyPayslipSummary(
      uuid: _str(json['uuid']),
      month: _str(_value(json['month']) ?? json['month']),
      label: _str(
        json['label'] ?? json['month_label'] ?? _value(json['month']),
      ),
      status: _str(json['status']),
      netPay: _num(json['net_pay'] ?? json['amount']),
      currency: _str(json['currency']),
    );
  }

  bool get isPaid => status == 'paid';

  Map<String, dynamic> toRouteArguments() => {
    'uuid': uuid,
    'monthKey': label.isNotEmpty ? label : month,
    'amount': formatMoney(netPay, currency),
    'isPaid': isPaid,
  };
}

class MoneyPayslipDetailModel {
  final MoneyPayslipSummary summary;
  final Map<String, String> employee;
  final List<MoneyLineItem> earnings;
  final List<MoneyLineItem> deductions;
  final MoneyLineItem? payment;
  final double grossPay;
  final double totalDeductions;
  final double netPay;
  final String currency;

  const MoneyPayslipDetailModel({
    required this.summary,
    required this.employee,
    required this.earnings,
    required this.deductions,
    required this.payment,
    required this.grossPay,
    required this.totalDeductions,
    required this.netPay,
    required this.currency,
  });

  factory MoneyPayslipDetailModel.fromJson(Map<String, dynamic> json) {
    final data = _data(json);
    final currency = _currency(data);
    final earnings = _lineItems(data['earnings'], fallbackCurrency: currency);
    final deductions = _lineItems(
      data['deductions'],
      fallbackCurrency: currency,
    );
    final employee = _mapAny(data, const ['employee', 'employee_snapshot']);
    return MoneyPayslipDetailModel(
      summary: MoneyPayslipSummary.fromJson(data),
      employee: {
        'name': _str(employee['name']),
        'code': _str(employee['code'] ?? employee['employee_code']),
        'role': _str(employee['role'] ?? employee['role_snapshot']),
        'branch': _str(employee['branch'] ?? employee['branch_snapshot']),
      },
      earnings: earnings,
      deductions: deductions,
      payment: _nullableMap(data['payment']) == null
          ? null
          : MoneyLineItem.fromJson(_map(data['payment'])),
      grossPay: _num(data['gross_pay']),
      totalDeductions: _num(data['total_deductions']),
      netPay: _num(data['net_pay']),
      currency: currency,
    );
  }
}

class MoneyLineItem {
  final String title;
  final String subtitle;
  final double amount;
  final String currency;
  final String status;
  final String type;
  final String source;

  const MoneyLineItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.currency,
    required this.status,
    required this.type,
    required this.source,
  });

  factory MoneyLineItem.fromJson(Map<String, dynamic> json) {
    return MoneyLineItem.fromJsonWithFallback(json);
  }

  factory MoneyLineItem.fromJsonWithFallback(
    Map<String, dynamic> json, {
    String fallbackCurrency = '',
  }) {
    final currency = _currency(json);
    return MoneyLineItem(
      title: _str(
        json['title'] ?? json['reason'] ?? json['type'] ?? json['label'],
      ),
      subtitle: _str(
        json['subtitle'] ?? json['notes'] ?? json['effective_date'],
      ),
      amount: _num(json['amount']),
      currency: currency.isNotEmpty ? currency : fallbackCurrency,
      status: _str(json['status']),
      type: _str(json['type'] ?? json['category'] ?? json['classification']),
      source: _str(json['source']),
    );
  }
}

class MoneyBonusResponse {
  final double total;
  final String currency;
  final List<MoneyLineItem> categories;
  final List<MoneyLineItem> items;

  const MoneyBonusResponse({
    required this.total,
    required this.currency,
    required this.categories,
    required this.items,
  });

  factory MoneyBonusResponse.fromJson(Map<String, dynamic> json) {
    final data = _data(json);
    final currency = _currency(data);
    final items = _lineItems(
      data['items'] ?? data['bonuses'] ?? json['data'],
      fallbackCurrency: currency,
    );
    return MoneyBonusResponse(
      total: _num(data['total'] ?? data['monthly_total'] ?? data['amount']),
      currency: currency,
      categories: _lineItems(
        data['by_category'] ?? data['categories'] ?? data['by_type'],
        fallbackCurrency: currency,
      ),
      items: items,
    );
  }
}

class MoneyDeductionResponse {
  final double total;
  final String currency;
  final List<MoneyLineItem> categories;
  final List<MoneyLineItem> items;

  const MoneyDeductionResponse({
    required this.total,
    required this.currency,
    required this.categories,
    required this.items,
  });

  factory MoneyDeductionResponse.fromJson(Map<String, dynamic> json) {
    final data = _data(json);
    final currency = _currency(data);
    final items = _lineItems(
      data['items'] ?? data['deductions'] ?? json['data'],
      fallbackCurrency: currency,
    );
    return MoneyDeductionResponse(
      total: _num(data['total'] ?? data['monthly_total'] ?? data['amount']),
      currency: currency,
      categories: _lineItems(
        data['by_category'] ?? data['categories'] ?? data['by_type'],
        fallbackCurrency: currency,
      ),
      items: items,
    );
  }
}

String formatMoney(
  double value,
  String currency, {
  bool plus = false,
  bool minus = false,
}) {
  final prefix = plus && value > 0
      ? '+ '
      : minus && value > 0
      ? '- '
      : '';
  final amount = value % 1 == 0
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2);
  return '$prefix${currency.isEmpty ? '' : '$currency '}$amount'.trim();
}

Map<String, dynamic> _data(Map<String, dynamic> json) =>
    _map(json['data']).isEmpty ? json : _map(json['data']);

Map<String, dynamic> _map(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

Map<String, dynamic>? _nullableMap(dynamic value) {
  if (value == null) return null;
  final map = _map(value);
  return map.isEmpty ? null : map;
}

Map<String, dynamic> _mapAny(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final map = _map(json[key]);
    if (map.isNotEmpty) return map;
  }
  return <String, dynamic>{};
}

List<Map<String, dynamic>> _list(dynamic value) {
  if (value is List) {
    return value.map(_map).where((item) => item.isNotEmpty).toList();
  }
  return const [];
}

List<MoneyLineItem> _lineItems(dynamic value, {String fallbackCurrency = ''}) {
  final list = _list(value);
  if (list.isNotEmpty) {
    return list
        .map(
          (item) => MoneyLineItem.fromJsonWithFallback(
            item,
            fallbackCurrency: fallbackCurrency,
          ),
        )
        .toList();
  }
  final map = _map(value);
  if (map.isEmpty) return const [];
  return map.entries.where((entry) => entry.value != null).map((entry) {
    final entryMap = _map(entry.value);
    if (entryMap.isNotEmpty) {
      return MoneyLineItem.fromJsonWithFallback({
        'title': entry.key,
        ...entryMap,
      }, fallbackCurrency: fallbackCurrency);
    }
    return MoneyLineItem.fromJsonWithFallback({
      'title': entry.key,
      'amount': entry.value,
    }, fallbackCurrency: fallbackCurrency);
  }).toList();
}

Object? _value(dynamic value) =>
    value is Map ? (value['value'] ?? value['label']) : value;

String _currency(Map<String, dynamic> json) {
  if (json.isEmpty) return '';

  final direct = _currencyValue(
    json['currency'] ??
        json['currency_code'] ??
        json['currencyCode'] ??
        json['currency_symbol'],
  );
  if (direct.isNotEmpty) return direct;

  for (final key in const [
    'totals',
    'summary',
    'money',
    'net_pay',
    'pay',
    'salary',
    'basic_salary',
    'payroll',
    'commission',
    'commission_summary',
    'bonus',
    'bonuses',
    'deduction',
    'deductions',
    'employee',
    'branch',
    'provider',
    'country',
  ]) {
    final map = _map(json[key]);
    if (map.isEmpty) continue;
    final currency = _currency(map);
    if (currency.isNotEmpty) return currency;
  }

  final currencies = json['currencies'];
  if (currencies is List && currencies.isNotEmpty) {
    for (final item in currencies) {
      final currency = _currency(_map(item));
      if (currency.isNotEmpty) return currency;
    }
  }

  return '';
}

String _currencyValue(dynamic value) {
  if (value is Map) {
    return _str(
      value['code'] ??
          value['currency'] ??
          value['currency_code'] ??
          value['value'] ??
          value['symbol'],
    );
  }
  return _str(value);
}

String _str(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  return value.toString();
}

double _num(dynamic value) {
  if (value is Map) {
    return _num(
      value['amount'] ??
          value['value'] ??
          value['total'] ??
          value['net_pay'] ??
          value['gross_pay'] ??
          value['price'] ??
          value['current'] ??
          value['target'],
    );
  }
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}

int _int(dynamic value, {int fallback = 0}) {
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}
