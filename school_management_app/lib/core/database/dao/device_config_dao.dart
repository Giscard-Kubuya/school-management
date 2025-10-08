import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:school_management_app/core/errors/exceptions.dart';
import 'package:school_management_app/core/data/models/device_auth/device_configuration_model.dart';
import '../database_service.dart';
import '../database_tables.dart';

/// Data Access Object for Device Configuration operations
class DeviceConfigDao {
  final DatabaseService _databaseService;

  DeviceConfigDao(this._databaseService);

  /// Converts a database map to a DeviceConfiguration model
  DeviceConfiguration _fromMap(Map<String, dynamic> map) =>
      DeviceConfiguration.fromJson(map);

  /// Converts a DeviceConfiguration model to a database map
  Map<String, dynamic> _toMap(DeviceConfiguration config) => config.toJson();

  /// Inserts a new device configuration into the database
  /// Returns the ID of the inserted configuration
  Future<String> insert(DeviceConfiguration config) async {
    final id = await _databaseService.insert(
      DatabaseTables.deviceConfigurations,
      _toMap(config),
    );
    return id.toString();
  }

  /// Updates an existing device configuration
  /// Returns the number of rows affected
  Future<int> update(DeviceConfiguration config) async {
    if (config.id.isEmpty) {
      throw ArgumentError('Cannot update configuration without an ID');
    }

    final map = _toMap(config);
    map['updated_at'] = DateTime.now().toIso8601String();

    return await _databaseService.update(
      DatabaseTables.deviceConfigurations,
      map,
      where: 'id = ?',
      whereArgs: [config.id],
    );
  }

  /// Deletes a device configuration by ID
  Future<int> delete(String id) async {
    return await _databaseService.delete(
      DatabaseTables.deviceConfigurations,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Retrieves a device configuration by ID
  Future<DeviceConfiguration?> getById(String id) async {
    final results = await _databaseService.query(
      DatabaseTables.deviceConfigurations,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return results.isNotEmpty ? _fromMap(results.first) : null;
  }

  /// Retrieves device configuration by device UUID
  Future<DeviceConfiguration?> getByDeviceId(String deviceUuid) async {
    try {
      final results = await _databaseService.query(
        DatabaseTables.deviceConfigurations,
        where: 'device_uuid = ?',
        whereArgs: [deviceUuid],
        limit: 1,
      );
      return results.isNotEmpty ? _fromMap(results.first) : null;
    } catch (e) {
      throw CacheException(message: 'Failed to get device config: $e');
    }
  }

  /// Checks if a device is registered and active
  Future<bool> isDeviceRegistered(String deviceUuid) async {
    try {
      final results = await _databaseService.query(
        DatabaseTables.deviceConfigurations,
        where: 'device_uuid = ? AND is_active = ?',
        whereArgs: [deviceUuid, 1],
        limit: 1,
      );
      return results.isNotEmpty;
    } catch (e) {
      throw CacheException(message: 'Failed to check device registration: $e');
    }
  }

  /// Gets the currently active device configuration
  Future<DeviceConfiguration?> getActiveConfig() async {
    try {
      final results = await _databaseService.query(
        DatabaseTables.deviceConfigurations,
        where: 'is_active = ?',
        whereArgs: [1],
        limit: 1,
      );
      return results.isNotEmpty ? _fromMap(results.first) : null;
    } catch (e) {
      throw CacheException(message: 'Failed to get active device config: $e');
    }
  }

  /// Deactivates all device configurations (useful for logout)
  Future<int> deactivateAll() async {
    try {
      return await _databaseService.update(
        DatabaseTables.deviceConfigurations,
        {'is_active': 0, 'updated_at': DateTime.now().toIso8601String()},
      );
    } catch (e) {
      throw CacheException(message: 'Failed to deactivate device configs: $e');
    }
  }

  /// Updates the last used timestamp for a device
  Future<void> updateLastUsed(String deviceUuid) async {
    try {
      await _databaseService.update(
        DatabaseTables.deviceConfigurations,
        {
          'last_used_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        },
        where: 'device_uuid = ?',
        whereArgs: [deviceUuid],
      );
    } catch (e) {
      throw CacheException(message: 'Failed to update last used timestamp: $e');
    }
  }
}
