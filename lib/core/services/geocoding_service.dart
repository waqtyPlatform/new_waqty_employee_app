import 'package:geocoding/geocoding.dart';

class GeocodingService {
  const GeocodingService._();

  static Future<List<Location>?> getLocationFromAddress(String address) async {
    try {
      return await locationFromAddress(address);
    } catch (_) {
      return null;
    }
  }

  static Future<List<Placemark>?> getPlaceMarkFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      return await placemarkFromCoordinates(latitude, longitude);
    } catch (_) {
      return null;
    }
  }

  static Future<String?> getAddressFromLatLng({
    required double latitude,
    required double longitude,
  }) async {
    final placemarks = await getPlaceMarkFromCoordinates(latitude, longitude);
    if (placemarks == null || placemarks.isEmpty) return null;

    final place = placemarks.first;
    final addressParts = [
      place.street,
      place.subLocality,
      place.locality,
      place.administrativeArea,
      place.country,
    ].where((value) => value != null && value.trim().isNotEmpty).toList();

    return addressParts.join(', ');
  }
}
