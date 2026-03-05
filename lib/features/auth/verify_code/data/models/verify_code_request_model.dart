class VerifyCodeRequestModel {
  String email;
  String code;

  VerifyCodeRequestModel({required this.email, required this.code});

  Map<String, dynamic> toJson() => {"email": email, "code": code};
}
