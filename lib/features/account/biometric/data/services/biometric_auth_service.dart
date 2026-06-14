import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  final LocalAuthentication _localAuthentication;
  final DeviceInfoPlugin _deviceInfoPlugin;

  const BiometricAuthService(this._localAuthentication, this._deviceInfoPlugin);

  Future<bool> isDeviceSupported() async {
    try {
      return _localAuthentication.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> canCheckBiometrics() async {
    try {
      return _localAuthentication.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return _localAuthentication.getAvailableBiometrics();
    } catch (_) {
      return <BiometricType>[];
    }
  }

  Future<bool> hasEnrolledBiometrics() async {
    final isSupported = await isDeviceSupported();
    if (!isSupported) return false;

    final canCheck = await canCheckBiometrics();
    if (!canCheck) return false;

    final biometrics = await getAvailableBiometrics();
    return biometrics.isNotEmpty;
  }

  Future<bool> authenticate({required String reason}) async {
    try {
      final hasBiometrics = await hasEnrolledBiometrics();
      if (!hasBiometrics) return false;

      return _localAuthentication.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  Future<void> openSecuritySettings() async {
    try {
      await AppSettings.openAppSettings(type: AppSettingsType.security);
    } catch (_) {
      await AppSettings.openAppSettings();
    }
  }

  Future<String> getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfoPlugin.androidInfo;
        return info.model;
      }
      if (Platform.isIOS) {
        final info = await _deviceInfoPlugin.iosInfo;
        return info.utsname.machine;
      }
      if (Platform.isWindows) {
        final info = await _deviceInfoPlugin.windowsInfo;
        return info.computerName;
      }
      if (Platform.isMacOS) {
        final info = await _deviceInfoPlugin.macOsInfo;
        return info.computerName;
      }
      if (Platform.isLinux) {
        final info = await _deviceInfoPlugin.linuxInfo;
        return info.prettyName;
      }
    } catch (_) {
      return 'This device';
    }
    return 'This device';
  }

  Future<String> getBiometricMethodLabel() async {
    final biometrics = await getAvailableBiometrics();
    if (biometrics.contains(BiometricType.face)) {
      return 'Face ID';
    }
    if (biometrics.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    }
    if (biometrics.contains(BiometricType.iris)) {
      return 'Iris';
    }
    if (biometrics.contains(BiometricType.strong) ||
        biometrics.contains(BiometricType.weak)) {
      return 'Biometric';
    }
    return 'Not available';
  }
}
