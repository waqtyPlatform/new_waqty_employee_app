class EndPoints {
  // Android emulator -> host loopback. iOS/desktop: http://127.0.0.1:8000
  static const String baseUrl = "http://10.0.2.2:8006";
  // static const String baseUrl = "https://waqty.alemtayaz.shop/public";
  // static const String _imageBaseUrl = "storage/app/public/";

  static const String employeeAuthRefresh =
      "$baseUrl/api/employee/auth/refresh";
  static const String employeeAuthLogout = "$baseUrl/api/employee/auth/logout";
  static const String employeeDeviceToken =
      "$baseUrl/api/employee/device-token";

  // String getImageFromApi(String imageUrl) {
  //   return baseUrl + _imageBaseUrl + imageUrl;
  // }
}
