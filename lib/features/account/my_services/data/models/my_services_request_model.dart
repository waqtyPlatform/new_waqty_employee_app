class ProfileRequestModel {
  String name;
  String email;
  String phone;

  ProfileRequestModel({
    required this.name,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phone": phone,
  };
}
