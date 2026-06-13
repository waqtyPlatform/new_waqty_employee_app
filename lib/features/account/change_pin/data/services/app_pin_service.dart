import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_waqty_employee_app/core/utils/constant_keys.dart';
import 'package:new_waqty_employee_app/features/account/change_pin/data/services/app_pin_storage_keys.dart';

class AppPinService {
  final FlutterSecureStorage _secureStorage;

  static const int _saltLength = 32;
  static const int _hashLength = 32;
  static const int _iterations = 210000;
  static const int _temporaryLockSeconds = 30;
  static const int _temporaryLockThreshold = 3;
  static const int _forceLogoutThreshold = 5;

  const AppPinService(this._secureStorage);

  Future<bool> isPinEnabled() async {
    final enabled = await _secureStorage.read(
      key: AppPinStorageKeys.appPinEnabled,
    );
    return enabled == 'true';
  }

  Future<void> setPin(String pin) async {
    final salt = _generateSalt();
    final hash = await _hashPin(pin: pin, salt: salt);

    await _secureStorage.write(
      key: AppPinStorageKeys.appPinHash,
      value: base64Encode(hash),
    );
    await _secureStorage.write(
      key: AppPinStorageKeys.appPinSalt,
      value: base64Encode(salt),
    );
    await _secureStorage.write(
      key: AppPinStorageKeys.appPinEnabled,
      value: 'true',
    );
    await resetFailedAttempts();
  }

  Future<bool> verifyPin(String pin) async {
    final storedHash = await _secureStorage.read(
      key: AppPinStorageKeys.appPinHash,
    );
    final storedSalt = await _secureStorage.read(
      key: AppPinStorageKeys.appPinSalt,
    );

    if (storedHash == null ||
        storedHash.isEmpty ||
        storedSalt == null ||
        storedSalt.isEmpty) {
      return false;
    }

    final expectedHash = base64Decode(storedHash);
    final salt = base64Decode(storedSalt);
    final actualHash = await _hashPin(pin: pin, salt: salt);
    return _constantTimeEquals(actualHash, expectedHash);
  }

  Future<bool> changePin({
    required String currentPin,
    required String newPin,
  }) async {
    final isCurrentPinValid = await verifyPin(currentPin);
    if (!isCurrentPinValid) return false;

    await setPin(newPin);
    return true;
  }

  Future<bool> disablePin(String currentPin) async {
    final isCurrentPinValid = await verifyPin(currentPin);
    if (!isCurrentPinValid) return false;

    await clearPinData();
    return true;
  }

  Future<void> clearPinData() async {
    await _secureStorage.delete(key: AppPinStorageKeys.appPinHash);
    await _secureStorage.delete(key: AppPinStorageKeys.appPinSalt);
    await _secureStorage.write(
      key: AppPinStorageKeys.appPinEnabled,
      value: 'false',
    );
    await resetFailedAttempts();
  }

  Future<int> increaseFailedAttempts() async {
    final currentAttempts = await getFailedAttempts();
    final nextAttempts = currentAttempts + 1;
    await _secureStorage.write(
      key: AppPinStorageKeys.failedAttempts,
      value: nextAttempts.toString(),
    );

    if (nextAttempts >= _temporaryLockThreshold &&
        nextAttempts < _forceLogoutThreshold) {
      final lockedUntil = DateTime.now().add(
        const Duration(seconds: _temporaryLockSeconds),
      );
      await _secureStorage.write(
        key: AppPinStorageKeys.lockedUntil,
        value: lockedUntil.millisecondsSinceEpoch.toString(),
      );
    }

    return nextAttempts;
  }

  Future<void> resetFailedAttempts() async {
    await _secureStorage.delete(key: AppPinStorageKeys.failedAttempts);
    await _secureStorage.delete(key: AppPinStorageKeys.lockedUntil);
  }

  Future<DateTime?> getLockedUntil() async {
    final rawValue = await _secureStorage.read(
      key: AppPinStorageKeys.lockedUntil,
    );
    final milliseconds = int.tryParse(rawValue ?? '');
    if (milliseconds == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  Future<bool> isLocked() async {
    final lockedUntil = await getLockedUntil();
    if (lockedUntil == null) return false;

    final isStillLocked = lockedUntil.isAfter(DateTime.now());
    if (!isStillLocked) {
      await _secureStorage.delete(key: AppPinStorageKeys.lockedUntil);
    }
    return isStillLocked;
  }

  Future<int> getFailedAttempts() async {
    final rawValue = await _secureStorage.read(
      key: AppPinStorageKeys.failedAttempts,
    );
    return int.tryParse(rawValue ?? '') ?? 0;
  }

  Future<bool> shouldForceLogout() async {
    final attempts = await getFailedAttempts();
    return attempts >= _forceLogoutThreshold;
  }

  Future<void> clearLoginToken() async {
    await _secureStorage.delete(key: ConstantKeys.saveTokenToShared);
  }

  Future<void> forgotPin() async {
    await clearLoginToken();
    await clearPinData();
  }

  Future<List<int>> _hashPin({
    required String pin,
    required List<int> salt,
  }) async {
    final algorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: _iterations,
      bits: _hashLength * 8,
    );
    final secretKey = await algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(pin)),
      nonce: salt,
    );
    return secretKey.extractBytes();
  }

  List<int> _generateSalt() {
    final random = Random.secure();
    return List<int>.generate(_saltLength, (_) => random.nextInt(256));
  }

  bool _constantTimeEquals(List<int> a, List<int> b) {
    var diff = a.length ^ b.length;
    final maxLength = max(a.length, b.length);

    for (var i = 0; i < maxLength; i++) {
      final aByte = i < a.length ? a[i] : 0;
      final bByte = i < b.length ? b[i] : 0;
      diff |= aByte ^ bByte;
    }

    return diff == 0;
  }
}
