class VerifyCodeResponseModel {
  final String message;

  VerifyCodeResponseModel({required this.message});

  factory VerifyCodeResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyCodeResponseModel(message: json['message'] ?? '');
  }
}
