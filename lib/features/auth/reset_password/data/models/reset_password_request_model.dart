class ResetPasswordRequestModel {
  String email;
  String otp;
  String newPassword;
  String newPasswordConfirmation;

  ResetPasswordRequestModel({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "otp": otp,
    "new_password": newPassword,
    "new_password_confirmation": newPasswordConfirmation,
  };
}
