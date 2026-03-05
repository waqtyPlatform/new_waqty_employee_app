class ResetPasswordRequestModel {
  String email;
  String password;
  String passwordConfirmation;

  ResetPasswordRequestModel({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "password_confirmation": passwordConfirmation,
  };
}
