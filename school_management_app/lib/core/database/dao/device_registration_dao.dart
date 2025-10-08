import 'dart:async';
import 'package:school_management_app/core/errors/exceptions.dart';
import 'package:school_management_app/core/data/models/device_auth/device_registration_model.dart';
import '../database_service.dart';
import '../database_tables.dart';

/// Data Access Object for Device Registration operations
class DeviceRegistrationDao {
  final DatabaseService _databaseService;

  DeviceRegistrationDao(this._databaseService);

  /// Converts a database map to a DeviceRegistration model
  DeviceRegistration _fromMap(Map<String, dynamic> map) =>
      DeviceRegistration.fromJson(map);

  /// Converts a DeviceRegistration model to a database map
  Map<String, dynamic> _toMap(DeviceRegistration registration) =>
      registration.toJson();

  /// Inserts a new device registration into the database
  /// Returns the ID of the inserted registration
  Future<String> insert(DeviceRegistration registration) async {
    final id = await _databaseService.insert(
      DatabaseTables.deviceRegistrations,
      _toMap(registration),
    );
    return id.toString();
  }

  /// Updates an existing device registration
  /// Returns the number of rows affected
  Future<int> update(DeviceRegistration registration) async {
    if (registration.id.isEmpty) {
      throw ArgumentError('Cannot update registration without an ID');
    }

    final map = _toMap(registration);
    map['updated_at'] = DateTime.now().toIso8601String();

    return await _databaseService.update(
      DatabaseTables.deviceRegistrations,
      map,
      where: 'id = ?',
      whereArgs: [registration.id],
    );
  }

  /// Deletes a device registration by ID
  Future<int> delete(String id) async {
    return await _databaseService.delete(
      DatabaseTables.deviceRegistrations,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Retrieves a device registration by ID
  Future<DeviceRegistration?> getById(String id) async {
    final results = await _databaseService.query(
      DatabaseTables.deviceRegistrations,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return results.isNotEmpty ? _fromMap(results.first) : null;
  }

  /// Retrieves device registration by device UUID
  Future<DeviceRegistration?> getByDeviceId(String deviceUuid) async {
    try {
      final results = await _databaseService.query(
        DatabaseTables.deviceRegistrations,
        where: 'device_uuid = ?',
        whereArgs: [deviceUuid],
        limit: 1,
      );
      return results.isNotEmpty ? _fromMap(results.first) : null;
    } catch (e) {
      throw CacheException(message: 'Failed to get device registration: $e');
    }
  }

  /// Retrieves device registration by verification code
  Future<DeviceRegistration?> getByVerificationCode(String code) async {
    try {
      final now = DateTime.now().toIso8601String();
      final results = await _databaseService.query(
        DatabaseTables.deviceRegistrations,
        where: 'verification_code = ? AND expires_at > ?',
        whereArgs: [code, now],
        limit: 1,
      );
      return results.isNotEmpty ? _fromMap(results.first) : null;
    } catch (e) {
      throw CacheException(message: 'Failed to get registration by code: $e');
    }
  }

  /// Marks a registration as used
  Future<int> markAsUsed(String registrationId) async {
    try {
      return await _databaseService.update(
        DatabaseTables.deviceRegistrations,
        {'is_used': 1, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [registrationId],
      );
    } catch (e) {
      throw CacheException(message: 'Failed to mark registration as used: $e');
    }
  }

  /// Updates FCM token for a device
  Future<void> updateFcmToken(String deviceUuid, String fcmToken) async {
    try {
      await _databaseService.update(
        DatabaseTables.deviceRegistrations,
        {
          'fcm_token': fcmToken,
          'fcm_token_updated_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'device_uuid = ?',
        whereArgs: [deviceUuid],
      );
    } catch (e) {
      throw CacheException(message: 'Failed to update FCM token: $e');
    }
  }

  /// Updates the last login timestamp for a device
  Future<void> updateLastLogin(String deviceUuid, String ipAddress) async {
    try {
      await _databaseService.update(
        DatabaseTables.deviceRegistrations,
        {
          'last_login_at': DateTime.now().toIso8601String(),
          'last_ip_address': ipAddress,
          'login_attempts': 0, // Reset login attempts on successful login
          'is_locked': 0, // Unlock account if it was locked
          'locked_until': null, // Clear any lock expiration
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'device_uuid = ?',
        whereArgs: [deviceUuid],
      );
    } catch (e) {
      throw CacheException(message: 'Failed to update last login: $e');
    }
  }

  /// Increments the failed login attempts counter
  Future<void> incrementFailedLoginAttempts(String deviceUuid) async {
    try {
      await _databaseService.rawQuery(
        '''
        UPDATE ${DatabaseTables.deviceRegistrations} 
        SET login_attempts = login_attempts + 1,
            updated_at = ?
        WHERE device_uuid = ?
        ''',
        [DateTime.now().toIso8601String(), deviceUuid],
      );
    } catch (e) {
      throw CacheException(message: 'Failed to increment login attempts: $e');
    }
  }

  /// Locks the device registration
  Future<void> lockDevice(String deviceUuid, Duration lockDuration) async {
    try {
      final lockUntil = DateTime.now().add(lockDuration);
      await _databaseService.update(
        DatabaseTables.deviceRegistrations,
        {
          'is_locked': 1,
          'locked_until': lockUntil.toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'device_uuid = ?',
        whereArgs: [deviceUuid],
      );
    } catch (e) {
      throw CacheException(message: 'Failed to lock device: $e');
    }
  }
}
