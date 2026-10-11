import 'dart:io';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:new_waqty_employee_app/features/account/working_hours/data/models/working_hours_response_model.dart';

import 'package:new_waqty_employee_app/features/account/profile/data/models/profile_response_model.dart';

enum BranchPresence { insideBranch, outsideBranch, unknown }

class GeofenceService {
  static const _channel = MethodChannel('waqty/geofence');

  Future<BranchPresence> getPresence() async {
    try {
      final value = await _channel.invokeMethod<String>('getPresence');
      switch (value) {
        case 'inside_branch':
          return BranchPresence.insideBranch;
        case 'outside_branch':
          return BranchPresence.outsideBranch;
        default:
          return BranchPresence.unknown;
      }
    } on PlatformException {
      return BranchPresence.unknown;
    }
  }

  Future<bool> configureBranch({
    required BranchModel branch,
    required String languageCode,
  }) async {
    if (branch.uuid.isEmpty ||
        branch.latitude == null ||
        branch.longitude == null ||
        branch.attendanceRangeMeters == null ||
        branch.attendanceRangeMeters! <= 0) {
      await clear();
      return false;
    }
    try {
      return await _channel.invokeMethod<bool>('configure', {
            'branch_uuid': branch.uuid,
            'branch_name': branch.name,
            'latitude': branch.latitude,
            'longitude': branch.longitude,
            'radius_meters': branch.attendanceRangeMeters,
            'language': languageCode == 'en' ? 'en' : 'ar',
            'timezone': branch.timezone,
          }) ==
          true;
    } on PlatformException {
      return false;
    }
  }

  Future<void> syncSchedule({
    required List<WorkingHoursModel> shifts,
    String? timezone,
  }) async {
    final windows = <Map<String, dynamic>>[];
    for (final shift in shifts) {
      if (shift.shiftDate.isEmpty || shift.isDayOff) continue;
      final periods = shift.periods.isEmpty
          ? <Map<String, dynamic>>[
              {'start': shift.startTime, 'end': shift.endTime},
            ]
          : shift.periods
                .map(
                  (period) => <String, dynamic>{
                    'start': period.startTime,
                    'end': period.endTime,
                  },
                )
                .toList();
      for (final period in periods) {
        final start = period['start'] as String;
        final end = period['end'] as String;
        if (start.isEmpty || end.isEmpty) continue;
        windows.add({'date': shift.shiftDate, 'start': start, 'end': end});
      }
    }
    try {
      await _channel.invokeMethod<void>('updateSchedule', {
        'schedule': windows,
        'timezone': timezone,
      });
    } on PlatformException {
      // Schedule refresh must not block the current screen.
    }
  }

  Future<bool> requestPermissionsAndConfigure({
    required BranchModel branch,
    required String languageCode,
  }) async {
    if (!await Geolocator.isLocationServiceEnabled()) return false;
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
      }
      return false;
    }
    if (permission == LocationPermission.whileInUse) {
      if (Platform.isIOS) {
        try {
          await _channel.invokeMethod<void>('requestAlwaysPermission');
        } on PlatformException {
          // The user can grant Always later from Settings.
        }
      } else {
        await Geolocator.openAppSettings();
      }
      return false;
    }
    return configureBranch(branch: branch, languageCode: languageCode);
  }

  Future<void> clear() async {
    try {
      await _channel.invokeMethod<void>('clear');
    } on PlatformException {
      // Cleanup must not block logout.
    }
  }
}
