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
    final data = json['data'] ?? {};
    return LoginResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: data['token'] ?? '',
      tokenType: data['token_type'] ?? '',
      expiresIn: data['expires_in'] ?? 0,
      employee: Employee.fromJson(data['employee'] ?? {}),
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
      uuid: json['uuid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      branch: Branch.fromJson(json['branch'] ?? {}),
      active: json['active'] ?? false,
      blocked: json['blocked'] ?? false,
    );
  }
}

class Branch {
  final String uuid;
  final String name;

  Branch({required this.uuid, required this.name});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(uuid: json['uuid'] ?? '', name: json['name'] ?? '');
  }
}
