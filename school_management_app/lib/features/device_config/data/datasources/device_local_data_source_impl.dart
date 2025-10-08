import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:school_management_app/core/errors/exceptions.dart';
import 'package:school_management_app/core/database/database_helper.dart';
import 'package:school_management_app/features/device_config/data/datasources/device_local_data_source.dart';
import 'package:school_management_app/core/data/models/device_auth/device_configuration_model.dart';
import 'package:school_management_app/core/data/models/device_auth/device_registration_model.dart';

/// Implementation of [DeviceLocalDataSource] that uses [DatabaseHelper] for local storage
class DeviceLocalDataSourceImpl implements DeviceLocalDataSource {
  final DatabaseHelper _databaseHelper;

  DeviceLocalDataSourceImpl(this._databaseHelper);

  // Helper method to get database instance
  Future<Database> get _database => _databaseHelper.database;

  @override
  Future<void> cacheDeviceConfig(DeviceConfiguration config) async {
    try {
      final db = await _database;
      await db.insert(
        'device_configurations',
        config.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to cache device config: $e');
    }
  }

  @override
  Future<DeviceConfiguration?> getCachedDeviceConfig() async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        'device_configurations',
        where: 'is_active = ?',
        whereArgs: [1],
        limit: 1,
      );
      return maps.isNotEmpty ? DeviceConfiguration.fromJson(maps.first) : null;
    } catch (e) {
      throw CacheException(message: 'Failed to get cached device config: $e');
    }
  }

  @override
  Future<void> setVerificationStatus({
    required String deviceId,
    required String status,
    String? verificationCode,
    DateTime? expiresAt,
  }) async {
    try {
      final db = await _database;
      await db.update(
        'device_registrations',
        {
          'verification_status': status,
          if (verificationCode != null) 'verification_code': verificationCode,
          if (expiresAt != null) 'verification_expires_at': expiresAt.toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'device_uuid = ?',
        whereArgs: [deviceId],
      );
    } catch (e) {
      throw CacheException(message: 'Failed to update verification status: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getVerificationStatus(String deviceId) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> result = await db.query(
        'device_registrations',
        columns: [
          'verification_status',
          'verification_code',
          'verification_expires_at',
        ],
        where: 'device_uuid = ?',
        whereArgs: [deviceId],
      );
      
      if (result.isEmpty) return null;
      
      return {
        'status': result.first['verification_status'] as String? ?? 'pending',
        'code': result.first['verification_code'] as String?,
        'expiresAt': result.first['verification_expires_at'] != null
            ? DateTime.parse(result.first['verification_expires_at'] as String)
            : null,
      };
    } catch (e) {
      throw CacheException(message: 'Failed to get verification status: $e');
    }
  }

  @override
  Future<bool> isDeviceRegistered(String deviceId) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        'device_configurations',
        where: 'device_uuid = ? AND is_active = ?',
        whereArgs: [deviceId, 1],
        limit: 1,
      );
      final bool isRegistered = maps.isNotEmpty;
      print('Device registration check - Device ID: $deviceId, Registered: $isRegistered');
      return isRegistered;
    } catch (e) {
      throw CacheException(message: 'Failed to check device registration: $e');
    }
  }

  @override
  Future<void> updateLastUsed(String deviceId) async {
    try {
      final db = await _database;
      await db.update(
        'device_configurations',
        {'last_used_at': DateTime.now().toIso8601String()},
        where: 'device_uuid = ?',
        whereArgs: [deviceId],
      );
    } catch (e) {
      throw CacheException(message: 'Failed to update last used timestamp: $e');
    }
  }

  @override
  Future<void> deactivateDevice(String deviceId) async {
    try {
      final db = await _database;
      await db.update(
        'device_configurations',
        {'is_active': 0, 'updated_at': DateTime.now().toIso8601String()},
        where: 'device_uuid = ?',
        whereArgs: [deviceId],
      );
    } catch (e) {
      throw CacheException(message: 'Failed to deactivate device: $e');
    }
  }

  @override
  Future<void> cacheRegistration(DeviceRegistration registration) async {
    try {
      final db = await _database;
      await db.insert(
        'device_registrations',
        registration.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw CacheException(message: 'Failed to cache registration: $e');
    }
  }

  @override
  Future<DeviceRegistration?> getPendingRegistration(String deviceId) async {
    try {
      final db = await _database;
      final List<Map<String, dynamic>> maps = await db.query(
        'device_registrations',
        where: 'device_uuid = ? AND is_used = ?',
        whereArgs: [deviceId, 0],
        limit: 1,
      );
      return maps.isNotEmpty ? DeviceRegistration.fromJson(maps.first) : null;
    } catch (e) {
      throw CacheException(message: 'Failed to get pending registration: $e');
    }
  }

  @override
  Future<DeviceRegistration?> getRegistrationByCode(String code) async {
    try {
      final db = await _database;
      final now = DateTime.now().toIso8601String();
      final List<Map<String, dynamic>> maps = await db.query(
        'device_registrations',
        where: 'verification_code = ? AND (expires_at IS NULL OR expires_at > ?)',
        whereArgs: [code, now],
        limit: 1,
      );
      return maps.isNotEmpty ? DeviceRegistration.fromJson(maps.first) : null;
    } catch (e) {
      throw CacheException(message: 'Failed to get registration by code: $e');
    }
  }

  @override
  Future<void> markRegistrationAsUsed(String registrationId) async {
    try {
      final db = await _database;
      await db.update(
        'device_registrations',
        {'is_used': 1, 'updated_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [registrationId],
      );
    } catch (e) {
      throw CacheException(message: 'Failed to mark registration as used: $e');
    }
  }

  @override
  Future<void> updateFcmToken(String deviceId, String fcmToken) async {
    try {
      final db = await _database;
      await db.update(
        'device_registrations',
        {
          'fcm_token': fcmToken,
          'fcm_token_updated_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'device_uuid = ?',
        whereArgs: [deviceId],
      );
    } catch (e) {
      throw CacheException(message: 'Failed to update FCM token: $e');
    }
  }

  @override
  Future<void> updateLastLogin(String deviceId, String ipAddress) async {
    try {
      final db = await _database;
      await db.update(
        'device_registrations',
        {
          'last_login_at': DateTime.now().toIso8601String(),
          'last_ip_address': ipAddress,
          'login_attempts': 0,
          'is_locked': 0,
          'locked_until': null,
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'device_uuid = ?',
        whereArgs: [deviceId],
      );
    } catch (e) {
      throw CacheException(message: 'Failed to update last login: $e');
    }
  }
  
  @override
  Future<bool> needsVerification(String deviceId) async {
    try {
      final status = await getVerificationStatus(deviceId);
      if (status == null) return false;
      
      final isPending = status['status'] == 'pending';
      final isExpired = status['expiresAt']?.isBefore(DateTime.now()) ?? false;
      
      return isPending && !isExpired;
    } catch (e) {
      throw CacheException(message: 'Failed to check verification needs: $e');
    }
  }
  
  @override
  Future<void> incrementFailedLoginAttempts(String deviceId) async {
    try {
      final db = await _database;
      await db.rawUpdate('''
        UPDATE device_registrations 
        SET login_attempts = login_attempts + 1,
            updated_at = ?
        WHERE device_uuid = ?
      ''', [DateTime.now().toIso8601String(), deviceId]);
    } catch (e) {
      throw CacheException(message: 'Failed to increment login attempts: $e');
    }
  }

  @override
  Future<void> lockDevice(String deviceId, Duration lockDuration) async {
    try {
      final db = await _database;
      final lockUntil = DateTime.now().add(lockDuration);
      await db.update(
        'device_registrations',
        {
          'is_locked': 1,
          'locked_until': lockUntil.toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'device_uuid = ?',
        whereArgs: [deviceId],
      );
    } catch (e) {
      throw CacheException(message: 'Failed to lock device: $e');
    }
  }
}
