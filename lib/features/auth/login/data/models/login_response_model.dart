class LoginResponseModel {
  final bool success;
  final String message;
  final String token;
  final String tokenType;
  final int expiresIn;
  final Employee employee;

  LoginResponseModel({
    required this.success,
    required this.message,
    required this.token,
    required this.tokenType,
    required this.expiresIn,
    required this.employee,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = _asMap(json['data']);
    final employeeData = _asMap(
      data['employee'] ??
          data['user'] ??
          data['profile'] ??
          json['employee'] ??
          json['user'],
    );
    final dataToken = _firstString(data, const [
      'token',
      'access_token',
      'jwt',
    ]);
    final token = dataToken.isNotEmpty
        ? dataToken
        : _firstString(json, const ['token', 'access_token', 'jwt']);
    final dataTokenType = _firstString(data, const ['token_type', 'tokenType']);
    final tokenType = dataTokenType.isNotEmpty
        ? dataTokenType
        : _firstString(json, const ['token_type', 'tokenType']);
    final expiresIn = _asInt(
      data['expires_in'] ?? data['expiresIn'] ?? json['expires_in'],
    );

    return LoginResponseModel(
      success: json['success'] == true || token.isNotEmpty,
      message: _asString(json['message'] ?? data['message']),
      token: token,
      tokenType: tokenType,
      expiresIn: expiresIn,
      employee: Employee.fromJson(employeeData),
    );
  }
}

class Employee {
  final String uuid;
  final String name;
  final String email;
  final String phone;
  final Branch branch;
  final bool active;
  final bool blocked;

  Employee({
    required this.uuid,
    required this.name,
    required this.email,
    required this.phone,
    required this.branch,
    required this.active,
    required this.blocked,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      uuid: _asString(json['uuid'] ?? json['id']),
      name: _asString(json['name'] ?? json['full_name'] ?? json['fullName']),
      email: _asString(json['email']),
      phone: _asString(json['phone'] ?? json['mobile']),
      branch: Branch.fromJson(_asMap(json['branch'])),
      active: _asBool(json['active'] ?? json['is_active'] ?? true),
      blocked: _asBool(json['blocked'] ?? json['is_blocked']),
    );
  }
}

class Branch {
  final String uuid;
  final String name;

  Branch({required this.uuid, required this.name});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      uuid: _asString(json['uuid'] ?? json['id']),
      name: _asString(json['name']),
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

String _asString(dynamic value) => value?.toString() ?? '';

String _firstString(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    final value = _asString(json[key]);
    if (value.isNotEmpty) return value;
  }
  return '';
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final text = value?.toString().toLowerCase().trim();
  return text == 'true' || text == '1' || text == 'yes';
}
