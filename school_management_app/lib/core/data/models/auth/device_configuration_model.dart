import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class DeviceConfiguration extends BaseModel {
  final String id;
  final String universityId;
  final String deviceUuid;
  final String? deviceName;
  final String deviceType; // mobile, tablet, desktop, web
  final String? platform; // iOS, Android, Windows, MacOS, Web
  final String? platformVersion;
  final String? appVersion;
  final bool isConfigured;
  final bool isActive;
  final String? configurationToken;
  final DateTime? tokenExpiresAt;
  final DateTime? configuredAt;
  final String? configuredBy;
  final DateTime? lastUsedAt;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DeviceConfiguration({
    required this.id,
    required this.universityId,
    required this.deviceUuid,
    this.deviceName,
    this.deviceType = 'mobile',
    this.platform,
    this.platformVersion,
    this.appVersion,
    this.isConfigured = false,
    this.isActive = true,
    this.configurationToken,
    this.tokenExpiresAt,
    this.configuredAt,
    this.configuredBy,
    this.lastUsedAt,
    this.syncStatus = 'synced',
    this.syncVersion = 1,
    this.isDirty = false,
    this.lastSyncedAt,
    this.conflictData,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
          id: id,
          syncStatus: syncStatus,
          syncVersion: syncVersion,
          isDirty: isDirty,
          lastSyncedAt: lastSyncedAt,
          conflictData: conflictData,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  @override
  List<Object?> get props => [
        id,
        universityId,
        deviceUuid,
        deviceName,
        deviceType,
        platform,
        platformVersion,
        appVersion,
        isConfigured,
        isActive,
        configurationToken,
        tokenExpiresAt,
        configuredAt,
        configuredBy,
        lastUsedAt,
        syncStatus,
        syncVersion,
        isDirty,
        lastSyncedAt,
        conflictData,
        createdAt,
        updatedAt,
      ];

  factory DeviceConfiguration.fromJson(Map<String, dynamic> json) {
    return DeviceConfiguration(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      deviceUuid: json['device_uuid'] as String,
      deviceName: json['device_name'] as String?,
      deviceType: json['device_type'] as String? ?? 'mobile',
      platform: json['platform'] as String?,
      platformVersion: json['platform_version'] as String?,
      appVersion: json['app_version'] as String?,
      isConfigured: (json['is_configured'] as int?) == 1 || (json['is_configured'] as bool?) == true,
      isActive: (json['is_active'] as int?) != 0 && (json['is_active'] as bool?) != false,
      configurationToken: json['configuration_token'] as String?,
      tokenExpiresAt: json['token_expires_at'] != null
          ? DateTime.parse(json['token_expires_at'] as String)
          : null,
      configuredAt: json['configured_at'] != null
          ? DateTime.parse(json['configured_at'] as String)
          : null,
      configuredBy: json['configured_by'] as String?,
      lastUsedAt: json['last_used_at'] != null
          ? DateTime.parse(json['last_used_at'] as String)
          : null,
      syncStatus: json['sync_status'] as String? ?? 'synced',
      syncVersion: (json['sync_version'] as int?) ?? 1,
      isDirty: (json['is_dirty'] as int?) == 1 || (json['is_dirty'] as bool?) == true,
      lastSyncedAt: json['last_synced_at'] != null
          ? DateTime.parse(json['last_synced_at'] as String)
          : null,
      conflictData: json['conflict_data'] != null
          ? Map<String, dynamic>.from(json['conflict_data'] as Map)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'device_uuid': deviceUuid,
      'device_name': deviceName,
      'device_type': deviceType,
      'platform': platform,
      'platform_version': platformVersion,
      'app_version': appVersion,
      'is_configured': isConfigured ? 1 : 0,
      'is_active': isActive ? 1 : 0,
      'configuration_token': configurationToken,
      'token_expires_at': tokenExpiresAt?.toIso8601String(),
      'configured_at': configuredAt?.toIso8601String(),
      'configured_by': configuredBy,
      'last_used_at': lastUsedAt?.toIso8601String(),
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  DeviceConfiguration copyWith({
    String? id,
    String? universityId,
    String? deviceUuid,
    String? deviceName,
    String? deviceType,
    String? platform,
    String? platformVersion,
    String? appVersion,
    bool? isConfigured,
    bool? isActive,
    String? configurationToken,
    DateTime? tokenExpiresAt,
    DateTime? configuredAt,
    String? configuredBy,
    DateTime? lastUsedAt,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeviceConfiguration(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      deviceUuid: deviceUuid ?? this.deviceUuid,
      deviceName: deviceName ?? this.deviceName,
      deviceType: deviceType ?? this.deviceType,
      platform: platform ?? this.platform,
      platformVersion: platformVersion ?? this.platformVersion,
      appVersion: appVersion ?? this.appVersion,
      isConfigured: isConfigured ?? this.isConfigured,
      isActive: isActive ?? this.isActive,
      configurationToken: configurationToken ?? this.configurationToken,
      tokenExpiresAt: tokenExpiresAt ?? this.tokenExpiresAt,
      configuredAt: configuredAt ?? this.configuredAt,
      configuredBy: configuredBy ?? this.configuredBy,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      isDirty: isDirty ?? this.isDirty,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      conflictData: conflictData ?? this.conflictData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
