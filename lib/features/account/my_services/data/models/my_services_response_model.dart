class ProfileResponseModel {
  final ProfileCustomer customer;

  ProfileResponseModel({required this.customer});

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      customer: ProfileCustomer.fromJson(
        json['customer'] ?? json['data'] ?? json['user'] ?? {},
      ),
    );
  }
}

class ProfileCustomer {
  final String name;
  final String phone;
  final String email;

  ProfileCustomer({
    required this.name,
    required this.phone,
    required this.email,
  });

  factory ProfileCustomer.fromJson(Map<String, dynamic> json) {
    return ProfileCustomer(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
