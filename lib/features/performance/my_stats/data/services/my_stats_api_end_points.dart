class MyStatsApiEndPoints {
  static String performance({required String period}) {
    return '/api/employee/performance?period=$period';
  }

  static String ratings({
    int? rating,
    String? bookingUuid,
    String? fromDate,
    String? toDate,
    bool? active,
    int page = 1,
    int perPage = 15,
  }) {
    final params = <String, String>{
      'page': '$page',
      'per_page': '$perPage',
      if (rating != null) 'rating': '$rating',
      if (bookingUuid?.isNotEmpty == true) 'booking_uuid': bookingUuid!,
      if (fromDate?.isNotEmpty == true) 'from_date': fromDate!,
      if (toDate?.isNotEmpty == true) 'to_date': toDate!,
      if (active != null) 'active': active ? '1' : '0',
    };
    return '/api/employee/ratings?${Uri(queryParameters: params).query}';
  }
}
