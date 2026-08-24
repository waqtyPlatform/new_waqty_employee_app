class HomeSummaryModel {
  final String employeeName;
  final String employeeAvatarUrl;
  final String branchName;
  final String date;
  final String timezone;
  final bool clockedIn;
  final DateTime? clockedInAt;
  final int booked;
  final int done;
  final int left;
  final double rating;
  final int ratingsCount;
  final HomeEarningsModel earnings;
  final List<HomeAppointmentModel> appointments;
  final HomeReviewModel? latestReview;

  const HomeSummaryModel({
    required this.employeeName,
    required this.employeeAvatarUrl,
    required this.branchName,
    required this.date,
    required this.timezone,
    required this.clockedIn,
    required this.clockedInAt,
    required this.booked,
    required this.done,
    required this.left,
    required this.rating,
    required this.ratingsCount,
    required this.earnings,
    required this.appointments,
    required this.latestReview,
  });

  factory HomeSummaryModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);
    final employee = _asMap(data['employee']);
    final branch = _asMap(data['branch']);
    final workingStatus = _asMap(data['working_status']);
    final snapshot = _asMap(data['snapshot']);
    final upcomingAppointments = _asList(data['upcoming_appointments']);
    final latestReview = _asMap(data['latest_review']);

    return HomeSummaryModel(
      employeeName: _asString(
        employee['name'],
        fallback: _asString(employee['first_name']),
      ),
      employeeAvatarUrl: _asString(employee['avatar_url']),
      branchName: _asString(branch['name']),
      date: _asString(data['date']),
      timezone: _asString(data['timezone']),
      clockedIn: _asBool(workingStatus['clocked_in']),
      clockedInAt: _parseDate(workingStatus['clocked_in_at']),
      booked: _asInt(snapshot['booked']),
      done: _asInt(snapshot['done']),
      left: _asInt(snapshot['left']),
      rating: _asDouble(snapshot['rating_average']),
      ratingsCount: _asInt(snapshot['ratings_count']),
      earnings: HomeEarningsModel.fromJson(_asMap(data['earnings'])),
      appointments: upcomingAppointments
          .take(5)
          .map(HomeAppointmentModel.fromJson)
          .toList(),
      latestReview: latestReview.isEmpty
          ? null
          : HomeReviewModel.fromJson(latestReview),
    );
  }

  String get ratingLabel {
    if (ratingsCount == 0) return '--';
    if (rating == rating.roundToDouble()) return rating.toStringAsFixed(0);
    return rating.toStringAsFixed(1);
  }

  String get earningsLabel => earnings.displayAmount;
}

class HomeEarningsModel {
  final String calculationStatus;
  final bool payrollProcessed;
  final double amount;
  final String currency;
  final List<HomeEarningsCurrencyModel> currencies;

  const HomeEarningsModel({
    required this.calculationStatus,
    required this.payrollProcessed,
    required this.amount,
    required this.currency,
    required this.currencies,
  });

  factory HomeEarningsModel.fromJson(Map<String, dynamic> json) {
    return HomeEarningsModel(
      calculationStatus: _asString(json['calculation_status']),
      payrollProcessed: _asBool(json['payroll_processed']),
      amount: _asDouble(json['amount']),
      currency: _asString(json['currency']),
      currencies: _asList(
        json['currencies'],
      ).map(HomeEarningsCurrencyModel.fromJson).toList(),
    );
  }

  String get displayAmount {
    if (currency.isNotEmpty) return '$currency ${_money(amount)}';
    if (currencies.isEmpty) return '--';
    return currencies
        .map((item) => '${item.currency} ${_money(item.amount)}')
        .join(' · ');
  }
}

class HomeEarningsCurrencyModel {
  final String currency;
  final double amount;
  final double attributedServiceValue;

  const HomeEarningsCurrencyModel({
    required this.currency,
    required this.amount,
    required this.attributedServiceValue,
  });

  factory HomeEarningsCurrencyModel.fromJson(Map<String, dynamic> json) {
    return HomeEarningsCurrencyModel(
      currency: _asString(json['currency']),
      amount: _asDouble(json['amount']),
      attributedServiceValue: _asDouble(json['attributed_service_value']),
    );
  }
}

class HomeAppointmentModel {
  final String visitUuid;
  final String bookingUuid;
  final String status;
  final String customerName;
  final String customerAvatarUrl;
  final String servicesLabel;
  final String resourceName;
  final DateTime? scheduledStartAt;
  final DateTime? scheduledEndAt;

  const HomeAppointmentModel({
    required this.visitUuid,
    required this.bookingUuid,
    required this.status,
    required this.customerName,
    required this.customerAvatarUrl,
    required this.servicesLabel,
    required this.resourceName,
    required this.scheduledStartAt,
    required this.scheduledEndAt,
  });

  factory HomeAppointmentModel.fromJson(Map<String, dynamic> json) {
    final customer = _asMap(json['customer'] ?? json['user']);
    final services = _asList(json['services'])
        .map((service) => _asString(service['name']))
        .where((name) => name.isNotEmpty)
        .toList();
    final resource = _asMap(json['resource']);

    return HomeAppointmentModel(
      visitUuid: _asString(json['visit_uuid'] ?? json['uuid']),
      bookingUuid: _asString(
        json['booking_uuid'] ?? _asMap(json['booking'])['uuid'],
      ),
      status: _asString(json['status']),
      customerName: _asString(customer['name']),
      customerAvatarUrl: _asString(customer['avatar_url']),
      servicesLabel: services.join('، '),
      resourceName: _asString(resource['name']),
      scheduledStartAt: _parseDate(json['scheduled_start_at']),
      scheduledEndAt: _parseDate(json['scheduled_end_at']),
    );
  }

  String get dateLabel => _formatDate(scheduledStartAt);

  String get timeLabel {
    final start = _formatTime(scheduledStartAt);
    final end = _formatTime(scheduledEndAt);
    if (start.isEmpty) return end;
    if (end.isEmpty) return start;
    return '$start - $end';
  }

  String get slotLabel => resourceName;
}

class HomeReviewModel {
  final String reviewerName;
  final String reviewerAvatarUrl;
  final int rating;
  final String comment;
  final DateTime? ratedAt;
  final bool isAnonymous;

  const HomeReviewModel({
    required this.reviewerName,
    required this.reviewerAvatarUrl,
    required this.rating,
    required this.comment,
    required this.ratedAt,
    required this.isAnonymous,
  });

  factory HomeReviewModel.fromJson(Map<String, dynamic> json) {
    final customer = _asMap(json['customer'] ?? json['user']);
    final isAnonymous = _asBool(json['is_anonymous']);
    return HomeReviewModel(
      reviewerName: isAnonymous ? '' : _asString(customer['name']),
      reviewerAvatarUrl: isAnonymous ? '' : _asString(customer['avatar_url']),
      rating: _asInt(json['rating']),
      comment: _asString(json['comment']),
      ratedAt: _parseDate(json['rated_at'] ?? json['created_at']),
      isAnonymous: isAnonymous,
    );
  }

  String get relativeDateLabel {
    final date = ratedAt;
    if (date == null) return '';
    final days = DateTime.now().difference(date).inDays;
    if (days <= 0) return 'Today';
    if (days == 1) return 'Yesterday';
    if (days < 30) return '$days days ago';
    final months = (days / 30).floor();
    if (months == 1) return 'A month ago';
    if (months < 12) return '$months months ago';
    return _formatDate(date);
  }
}

const List<String> _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String _formatDate(DateTime? date) {
  if (date == null) return '';
  return '${_months[date.month - 1]} ${date.day}, ${date.year}';
}

String _formatTime(DateTime? date) {
  if (date == null) return '';
  final period = date.hour < 12 ? 'AM' : 'PM';
  final hour = date.hour == 0
      ? 12
      : (date.hour > 12 ? date.hour - 12 : date.hour);
  return '$hour:${date.minute.toString().padLeft(2, '0')} $period';
}

String _money(double value) {
  if (value == value.roundToDouble()) {
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (match) => '${match[1]},',
        );
  }
  return value.toStringAsFixed(2);
}

DateTime? _parseDate(dynamic value) {
  final text = _asString(value);
  if (text.isEmpty) return null;
  return DateTime.tryParse(text)?.toLocal();
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

String _asString(dynamic value, {String fallback = ''}) {
  if (value == null) return fallback;
  if (value is Map) {
    final map = Map<String, dynamic>.from(value);
    return _asString(map['ar'] ?? map['en'], fallback: fallback);
  }
  final text = value.toString().trim();
  if (text.isEmpty || text.toLowerCase() == 'null') return fallback;
  return text;
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value?.toString().toLowerCase().trim();
  return text == 'true' || text == '1' || text == 'yes';
}
