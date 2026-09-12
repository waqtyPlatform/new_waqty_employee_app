class EmployeeSearchResponseModel {
  final String query;
  final List<EmployeeSearchAppointmentModel> appointments;
  final List<EmployeeSearchCustomerModel> customers;

  const EmployeeSearchResponseModel({
    required this.query,
    required this.appointments,
    required this.customers,
  });

  factory EmployeeSearchResponseModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);
    return EmployeeSearchResponseModel(
      query: _asString(data['query']),
      appointments: _asList(
        data['appointments'],
      ).map(EmployeeSearchAppointmentModel.fromJson).toList(),
      customers: _asList(
        data['customers'],
      ).map(EmployeeSearchCustomerModel.fromJson).toList(),
    );
  }

  bool get isEmpty => appointments.isEmpty && customers.isEmpty;
}

class EmployeeCustomerAppointmentsResponseModel {
  final EmployeeSearchCustomerModel customer;
  final List<EmployeeSearchAppointmentModel> appointments;

  const EmployeeCustomerAppointmentsResponseModel({
    required this.customer,
    required this.appointments,
  });

  factory EmployeeCustomerAppointmentsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final data = _asMap(json['data']);
    return EmployeeCustomerAppointmentsResponseModel(
      customer: EmployeeSearchCustomerModel.fromJson(_asMap(data['customer'])),
      appointments: _asList(
        data['appointments'],
      ).map(EmployeeSearchAppointmentModel.fromJson).toList(),
    );
  }
}

class EmployeeSearchAppointmentModel {
  final String uuid;
  final String reference;
  final String status;
  final String bookingDate;
  final DateTime? scheduledStartAt;
  final DateTime? scheduledEndAt;
  final EmployeeSearchCustomerModel customer;
  final List<String> services;
  final int visitsCount;
  final String amount;
  final String currency;

  const EmployeeSearchAppointmentModel({
    required this.uuid,
    required this.reference,
    required this.status,
    required this.bookingDate,
    required this.scheduledStartAt,
    required this.scheduledEndAt,
    required this.customer,
    required this.services,
    required this.visitsCount,
    required this.amount,
    required this.currency,
  });

  factory EmployeeSearchAppointmentModel.fromJson(Map<String, dynamic> json) {
    final total = _asMap(json['total']);
    return EmployeeSearchAppointmentModel(
      uuid: _asString(json['uuid']),
      reference: _asString(json['reference']),
      status: _asString(json['status']),
      bookingDate: _asString(json['booking_date']),
      scheduledStartAt: _parseDate(json['scheduled_start_at']),
      scheduledEndAt: _parseDate(json['scheduled_end_at']),
      customer: EmployeeSearchCustomerModel.fromJson(_asMap(json['customer'])),
      services: _asList(json['services'])
          .map((service) => _asString(service['name']))
          .where((name) => name.isNotEmpty)
          .toList(),
      visitsCount: _asInt(json['visits_count']),
      amount: _asString(total['amount']),
      currency: _asString(total['currency']),
    );
  }

  String get servicesLabel => services.join('، ');
  String get totalLabel {
    if (amount.isEmpty && currency.isEmpty) return '';
    if (currency.isEmpty) return amount;
    if (amount.isEmpty) return currency;
    return '$currency $amount';
  }
}

class EmployeeSearchCustomerModel {
  final String uuid;
  final String name;
  final String initials;
  final String phone;
  final String email;
  final String avatarUrl;
  final int appointmentsCount;

  const EmployeeSearchCustomerModel({
    required this.uuid,
    required this.name,
    required this.initials,
    required this.phone,
    required this.email,
    required this.avatarUrl,
    required this.appointmentsCount,
  });

  factory EmployeeSearchCustomerModel.fromJson(Map<String, dynamic> json) {
    return EmployeeSearchCustomerModel(
      uuid: _asString(json['uuid']),
      name: _asString(json['name']),
      initials: _asString(json['initials']),
      phone: _asString(json['phone']),
      email: _asString(json['email']),
      avatarUrl: _asString(json['avatar_url']),
      appointmentsCount: _asInt(json['appointments_count']),
    );
  }
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

String _asString(dynamic value) {
  if (value == null) return '';
  final text = value.toString().trim();
  if (text.toLowerCase() == 'null') return '';
  return text;
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

DateTime? _parseDate(dynamic value) {
  final text = _asString(value);
  if (text.isEmpty) return null;
  return DateTime.tryParse(text);
}
