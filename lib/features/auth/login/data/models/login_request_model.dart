class LoginRequestModel {
  String email;
  String password;
  Map<String, dynamic>? deviceData;

  LoginRequestModel({
    required this.email,
    required this.password,
    this.deviceData,
  });

  Map<String, dynamic> toJson() {
    return {"email": email, "password": password, ...?deviceData};
  }
}
