/// Aggregated payload behind the home screen.
///
/// The backend has no single "home" endpoint, so this is assembled from four
/// calls: today's upcoming visits, today's completed visits, today's revenue
/// and the employee ratings feed.
class HomeSummaryModel {
  final String employeeName;
  final String branchName;
  final int booked;
  final int done;
  final int left;
  final double rating;
  final int ratingsCount;
  final double todayEarnings;
  final String currency;
  final List<HomeAppointmentModel> appointments;
  final HomeReviewModel? latestReview;

  const HomeSummaryModel({
    required this.employeeName,
    required this.branchName,
    required this.booked,
    required this.done,
    required this.left,
    required this.rating,
    required this.ratingsCount,
    required this.todayEarnings,
    required this.currency,
    required this.appointments,
    required this.latestReview,
  });

  /// `1.0` renders as `4.2`, whole values stay short: `5` instead of `5.0`.
  String get ratingLabel {
    if (ratingsCount == 0) return '—';
    if (rating == rating.roundToDouble()) return rating.toStringAsFixed(0);
    return rating.toStringAsFixed(1);
  }

  String get earningsLabel => '$currency ${_money(todayEarnings)}';

  static String _money(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (match) => '${match[1]},',
      );
    }
    return value.toStringAsFixed(2);
  }
}

/// One row of `GET /api/employee/booking-visits`.
class HomeVisitsPageModel {
  final List<HomeAppointmentModel> appointments;
  final int total;

  const HomeVisitsPageModel({required this.appointments, required this.total});

  factory HomeVisitsPageModel.fromJson(Map<String, dynamic> json) {
    final rows = json['data'] is List ? json['data'] as List : const [];
    return HomeVisitsPageModel(
      appointments: rows
          .whereType<Map>()
          .map(
            (row) =>
                HomeAppointmentModel.fromJson(Map<String, dynamic>.from(row)),
          )
          .toList(),
      total: _asInt(_asMap(_asMap(json['meta'])['pagination'])['total']),
    );
  }
}

class HomeAppointmentModel {
  final String visitUuid;
  final String bookingUuid;
  final String customerName;
  final String servicesLabel;
  final String branchName;
  final int? queueNumber;
  final DateTime? scheduledStartAt;

  const HomeAppointmentModel({
    required this.visitUuid,
    required this.bookingUuid,
    required this.customerName,
    required this.servicesLabel,
    required this.branchName,
    required this.queueNumber,
    required this.scheduledStartAt,
  });

  factory HomeAppointmentModel.fromJson(Map<String, dynamic> json) {
    final booking = _asMap(json['booking']);
    final customer = _asMap(json['customer'] ?? json['user']);
    final services = (json['services'] is List ? json['services'] as List : [])
        .whereType<Map>()
        .map((service) => _asString(service['name']))
        .where((name) => name.isNotEmpty)
        .toList();

    return HomeAppointmentModel(
      visitUuid: _asString(json['uuid']),
      bookingUuid: _asString(booking['uuid']),
      customerName: _asString(customer['name']),
      servicesLabel: services.join('، '),
      branchName: _asString(_asMap(json['branch'])['name']),
      queueNumber: _asNullableInt(json['daily_queue_number']),
      scheduledStartAt: DateTime.tryParse(
        _asString(json['scheduled_start_at']),
      )?.toLocal(),
    );
  }

  String get dateLabel => _formatDate(scheduledStartAt);

  String get timeLabel => _formatTime(scheduledStartAt);

  /// Third segment of the card subtitle — the queue slot when the backend
  /// assigned one, otherwise the branch.
  String get slotLabel =>
      queueNumber == null ? branchName : '#${queueNumber!}';

  String get avatarLetter {
    final name = customerName.trim();
    return name.isEmpty ? '?' : String.fromCharCode(name.runes.first);
  }
}

/// Only the two fields the home header renders — the profile feature owns the
/// full `auth/me` shape.
class HomeProfileModel {
  final String name;
  final String branchName;

  const HomeProfileModel({required this.name, required this.branchName});

  factory HomeProfileModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);
    return HomeProfileModel(
      name: _asString(data['name']),
      branchName: _asString(_asMap(data['branch'])['name']),
    );
  }
}

class HomeRevenueModel {
  final double totalRevenue;
  final int completedBookings;

  const HomeRevenueModel({
    required this.totalRevenue,
    required this.completedBookings,
  });

  factory HomeRevenueModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);
    return HomeRevenueModel(
      totalRevenue: _asDouble(data['total_revenue']),
      completedBookings: _asInt(data['completed_bookings']),
    );
  }
}

class HomeRatingsModel {
  final double average;
  final int count;
  final HomeReviewModel? latest;

  const HomeRatingsModel({
    required this.average,
    required this.count,
    required this.latest,
  });

  /// The endpoint returns a paginated list with no aggregate, so the average is
  /// computed over the rows actually fetched. See [HomeService.getRatings] for
  /// the page size that bounds it.
  factory HomeRatingsModel.fromJson(Map<String, dynamic> json) {
    final rows = (json['data'] is List ? json['data'] as List : const [])
        .whereType<Map>()
        .map((row) => Map<String, dynamic>.from(row))
        .toList();

    final scores = rows
        .map((row) => _asDouble(row['rating']))
        .where((score) => score > 0)
        .toList();

    rows.sort((a, b) {
      final left = DateTime.tryParse(_asString(a['rated_at']));
      final right = DateTime.tryParse(_asString(b['rated_at']));
      if (left == null || right == null) return 0;
      return right.compareTo(left);
    });

    return HomeRatingsModel(
      average: scores.isEmpty
          ? 0
          : scores.reduce((a, b) => a + b) / scores.length,
      count: scores.length,
      latest: rows.isEmpty ? null : HomeReviewModel.fromJson(rows.first),
    );
  }
}

class HomeReviewModel {
  final String reviewerName;
  final int rating;
  final String comment;
  final DateTime? ratedAt;

  const HomeReviewModel({
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.ratedAt,
  });

  factory HomeReviewModel.fromJson(Map<String, dynamic> json) {
    final user = _asMap(json['user']);
    final isAnonymous = _asBool(json['is_anonymous']);
    return HomeReviewModel(
      reviewerName: isAnonymous ? 'Anonymous' : _asString(user['name']),
      rating: _asInt(json['rating']),
      comment: _asString(json['comment']),
      ratedAt: DateTime.tryParse(_asString(json['rated_at']))?.toLocal(),
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

int? _asNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString());
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
