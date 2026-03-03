
class EndPoints {
  static const String baseUrl = "https://wastelesslb.com/public/api/";
  static const String _imageBaseUrl = "storage/app/public/";

  String getImageFromApi(String imageUrl) {
    return baseUrl + _imageBaseUrl + imageUrl;
  }
}
