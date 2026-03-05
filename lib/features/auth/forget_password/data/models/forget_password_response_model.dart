class ForgetPasswordResponseModel {
  final String message;

  ForgetPasswordResponseModel({required this.message});

  factory ForgetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgetPasswordResponseModel(message: json['message'] ?? '');
  }
}
