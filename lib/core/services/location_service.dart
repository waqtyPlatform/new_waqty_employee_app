import 'package:geolocator/geolocator.dart';

export 'package:geolocator/geolocator.dart' show LocationAccuracy, Position;

enum LocationFailure {
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  unavailable,
}

class LocationResult {
  final Position? position;
  final LocationFailure? failure;

  const LocationResult._({this.position, this.failure});

  const LocationResult.success(Position position) : this._(position: position);

  const LocationResult.failure(LocationFailure failure)
    : this._(failure: failure);

  bool get hasPosition => position != null;
}

class AttendanceLocationResult {
  final Position? position;
  final LocationFailure? failure;
  final bool? isWithinBranchRange;
  final double? distanceMeters;

  const AttendanceLocationResult({
    this.position,
    this.failure,
    this.isWithinBranchRange,
    this.distanceMeters,
  });

  bool get hasPosition => position != null;
}

class YourLocation {
  const YourLocation._();

  static Future<LocationResult> getCurrentLocation({
    bool openAppSettingsOnDeniedForever = false,
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        if (openAppSettingsOnDeniedForever) {
          await Geolocator.openAppSettings();
        }
        return const LocationResult.failure(
          LocationFailure.permissionDeniedForever,
        );
      }

      if (permission == LocationPermission.denied) {
        return const LocationResult.failure(LocationFailure.permissionDenied);
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const LocationResult.failure(LocationFailure.serviceDisabled);
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: accuracy),
      );
      return LocationResult.success(position);
    } catch (_) {
      return const LocationResult.failure(LocationFailure.unavailable);
    }
  }

  static Future<AttendanceLocationResult> getAttendanceLocation({
    double? branchLatitude,
    double? branchLongitude,
    double? branchRangeMeters,
    bool openAppSettingsOnDeniedForever = true,
  }) async {
    final locationResult = await getCurrentLocation(
      openAppSettingsOnDeniedForever: openAppSettingsOnDeniedForever,
    );
    final position = locationResult.position;
    if (position == null) {
      return AttendanceLocationResult(failure: locationResult.failure);
    }

    final distance = distanceFromPositionToBranch(
      position: position,
      branchLatitude: branchLatitude,
      branchLongitude: branchLongitude,
    );

    return AttendanceLocationResult(
      position: position,
      distanceMeters: distance,
      isWithinBranchRange: isWithinBranchRange(
        distanceMeters: distance,
        branchRangeMeters: branchRangeMeters,
      ),
    );
  }

  static double? distanceFromPositionToBranch({
    required Position position,
    required double? branchLatitude,
    required double? branchLongitude,
  }) {
    if (branchLatitude == null || branchLongitude == null) return null;
    return Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      branchLatitude,
      branchLongitude,
    );
  }

  static bool? isWithinBranchRange({
    required double? distanceMeters,
    required double? branchRangeMeters,
  }) {
    if (distanceMeters == null ||
        branchRangeMeters == null ||
        branchRangeMeters <= 0) {
      return null;
    }
    return distanceMeters <= branchRangeMeters;
  }
}
