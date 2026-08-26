class MyReviewsResponseModel {
  final bool success;
  final List<MyReviewModel> reviews;
  final MyReviewsSummaryModel summary;
  final MyReviewsPaginationModel pagination;

  const MyReviewsResponseModel({
    required this.success,
    required this.reviews,
    required this.summary,
    required this.pagination,
  });

  factory MyReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final dataMap = _asMap(data);
    final rows = data is List ? data : dataMap['items'] ?? dataMap['reviews'];
    final summaryJson = _asMap(dataMap['summary'] ?? json['summary']);
    return MyReviewsResponseModel(
      success: _asBool(json['success'], fallback: true),
      reviews: _asList(rows).map(MyReviewModel.fromJson).toList(),
      summary: MyReviewsSummaryModel.fromJson(summaryJson),
      pagination: MyReviewsPaginationModel.fromJson(
        _asMap(_asMap(json['meta'])['pagination'] ?? json['meta']),
      ),
    );
  }
}

class MyReviewsSummaryModel {
  final double average;
  final int total;
  final Map<int, int> distribution;

  const MyReviewsSummaryModel({
    required this.average,
    required this.total,
    required this.distribution,
  });

  factory MyReviewsSummaryModel.fromJson(Map<String, dynamic> json) {
    final distribution = _asMap(json['distribution']);
    return MyReviewsSummaryModel(
      average: _asDouble(json['average']),
      total: _asInt(json['total']),
      distribution: distribution.map(
        (key, value) => MapEntry(int.tryParse(key) ?? 0, _asInt(value)),
      )..removeWhere((key, value) => key == 0),
    );
  }
}

class MyReviewModel {
  final String uuid;
  final int rating;
  final String comment;
  final DateTime? createdAt;
  final MyReviewCustomerModel customer;
  final MyReviewServiceModel service;
  final MyReviewBookingModel booking;

  const MyReviewModel({
    required this.uuid,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.customer,
    required this.service,
    required this.booking,
  });

  factory MyReviewModel.fromJson(Map<String, dynamic> json) {
    return MyReviewModel(
      uuid: _asString(json['uuid']),
      rating: _asInt(json['rating']),
      comment: _asString(json['comment']),
      createdAt: DateTime.tryParse(
        _asString(json['created_at'] ?? json['rated_at']),
      ),
      customer: MyReviewCustomerModel.fromJson(
        _asMap(json['customer'] ?? json['user']),
      ),
      service: MyReviewServiceModel.fromJson(_asMap(json['service'])),
      booking: MyReviewBookingModel.fromJson(_asMap(json['booking'])),
    );
  }
}

class MyReviewCustomerModel {
  final String uuid;
  final String name;
  final String phone;

  const MyReviewCustomerModel({
    required this.uuid,
    required this.name,
    required this.phone,
  });

  factory MyReviewCustomerModel.fromJson(Map<String, dynamic> json) {
    return MyReviewCustomerModel(
      uuid: _asString(json['uuid']),
      name: _asString(json['name']),
      phone: _asString(json['phone']),
    );
  }
}

class MyReviewServiceModel {
  final String uuid;
  final String name;

  const MyReviewServiceModel({required this.uuid, required this.name});

  factory MyReviewServiceModel.fromJson(Map<String, dynamic> json) {
    return MyReviewServiceModel(
      uuid: _asString(json['uuid']),
      name: _asString(json['name']),
    );
  }
}

class MyReviewBookingModel {
  final String uuid;
  final String reference;

  const MyReviewBookingModel({required this.uuid, required this.reference});

  factory MyReviewBookingModel.fromJson(Map<String, dynamic> json) {
    return MyReviewBookingModel(
      uuid: _asString(json['uuid']),
      reference: _asString(json['reference']),
    );
  }
}

class MyReviewsPaginationModel {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;

  const MyReviewsPaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory MyReviewsPaginationModel.fromJson(Map<String, dynamic> json) {
    return MyReviewsPaginationModel(
      currentPage: _asInt(json['current_page'], fallback: 1),
      perPage: _asInt(json['per_page'], fallback: 15),
      total: _asInt(json['total']),
      lastPage: _asInt(json['last_page'], fallback: 1),
    );
  }

  bool get hasMore => currentPage < lastPage;
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

bool _asBool(dynamic value, {bool fallback = false}) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value?.toString().toLowerCase().trim();
  if (text == 'true' || text == '1' || text == 'yes') return true;
  if (text == 'false' || text == '0' || text == 'no') return false;
  return fallback;
}
