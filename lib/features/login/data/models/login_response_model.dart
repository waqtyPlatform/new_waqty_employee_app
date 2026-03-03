class LoginResponseModel {
  final Customer customer;
  final String token;

  LoginResponseModel({required this.customer, required this.token});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      customer: Customer.fromJson(
        json['customer'] ?? json['data'] ?? json['user'] ?? {},
      ),
      token: json['token'] ?? '',
    );
  }
}

class Customer {
  final String name;
  final String phone;
  final String email;

  Customer({required this.name, required this.phone, required this.email});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
