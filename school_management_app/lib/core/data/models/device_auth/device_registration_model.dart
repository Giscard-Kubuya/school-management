import 'package:flutter/foundation.dart';
import '../base_model.dart';

@immutable
class DeviceRegistration extends BaseModel {
  final String id;
  final String universityId;
  final String? userId;
  final String deviceUuid;
  final String? deviceToken;
  final String? deviceName;
  final String? deviceModel;
  final String osType;
  final String? osVersion;
  final String? appVersion;
  final bool isActive;
  final DateTime? lastLoginAt;
  final String? lastIpAddress;
  final String? fcmToken;
  final DateTime? fcmTokenUpdatedAt;
  final bool isNotificationsEnabled;
  final int loginAttempts;
  final bool isLocked;
  final DateTime? lockedUntil;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DeviceRegistration({
    required this.id,
    required this.universityId,
    this.userId,
    required this.deviceUuid,
    this.deviceToken,
    this.deviceName,
    this.deviceModel,
    required this.osType,
    this.osVersion,
    this.appVersion,
    this.isActive = true,
    this.lastLoginAt,
    this.lastIpAddress,
    this.fcmToken,
    this.fcmTokenUpdatedAt,
    this.isNotificationsEnabled = true,
    this.loginAttempts = 0,
    this.isLocked = false,
    this.lockedUntil,
    this.syncStatus = 'synced',
    this.syncVersion = 1,
    this.isDirty = false,
    this.lastSyncedAt,
    this.conflictData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceRegistration.fromJson(Map<String, dynamic> json) {
    return DeviceRegistration(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      userId: json['user_id'] as String?,
      deviceUuid: json['device_uuid'] as String,
      deviceToken: json['device_token'] as String?,
      deviceName: json['device_name'] as String?,
      deviceModel: json['device_model'] as String?,
      osType: json['os_type'] as String,
      osVersion: json['os_version'] as String?,
      appVersion: json['app_version'] as String?,
      isActive:
          (json['is_active'] as int?) != 0 &&
          (json['is_active'] as bool?) != false,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
      lastIpAddress: json['last_ip_address'] as String?,
      fcmToken: json['fcm_token'] as String?,
      fcmTokenUpdatedAt: json['fcm_token_updated_at'] != null
          ? DateTime.parse(json['fcm_token_updated_at'] as String)
          : null,
      isNotificationsEnabled:
          (json['is_notifications_enabled'] as int?) != 0 &&
          (json['is_notifications_enabled'] as bool?) != false,
      loginAttempts: (json['login_attempts'] as int?) ?? 0,
      isLocked:
          (json['is_locked'] as int?) == 1 ||
          (json['is_locked'] as bool?) == true,
      lockedUntil: json['locked_until'] != null
          ? DateTime.parse(json['locked_until'] as String)
          : null,
      syncStatus: json['sync_status'] as String? ?? 'synced',
      syncVersion: (json['sync_version'] as int?) ?? 1,
      isDirty:
          (json['is_dirty'] as int?) == 1 ||
          (json['is_dirty'] as bool?) == true,
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
      'user_id': userId,
      'device_uuid': deviceUuid,
      'device_token': deviceToken,
      'device_name': deviceName,
      'device_model': deviceModel,
      'os_type': osType,
      'os_version': osVersion,
      'app_version': appVersion,
      'is_active': isActive ? 1 : 0,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'last_ip_address': lastIpAddress,
      'fcm_token': fcmToken,
      'fcm_token_updated_at': fcmTokenUpdatedAt?.toIso8601String(),
      'is_notifications_enabled': isNotificationsEnabled ? 1 : 0,
      'login_attempts': loginAttempts,
      'is_locked': isLocked ? 1 : 0,
      'locked_until': lockedUntil?.toIso8601String(),
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
    id,
    universityId,
    userId,
    deviceUuid,
    deviceToken,
    deviceName,
    deviceModel,
    osType,
    osVersion,
    appVersion,
    isActive,
    lastLoginAt,
    lastIpAddress,
    fcmToken,
    fcmTokenUpdatedAt,
    isNotificationsEnabled,
    loginAttempts,
    isLocked,
    lockedUntil,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  DeviceRegistration copyWith({
    String? id,
    String? universityId,
    String? userId,
    String? deviceUuid,
    String? deviceToken,
    String? deviceName,
    String? deviceModel,
    String? osType,
    String? osVersion,
    String? appVersion,
    bool? isActive,
    DateTime? lastLoginAt,
    String? lastIpAddress,
    String? fcmToken,
    DateTime? fcmTokenUpdatedAt,
    bool? isNotificationsEnabled,
    int? loginAttempts,
    bool? isLocked,
    DateTime? lockedUntil,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DeviceRegistration(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      userId: userId ?? this.userId,
      deviceUuid: deviceUuid ?? this.deviceUuid,
      deviceToken: deviceToken ?? this.deviceToken,
      deviceName: deviceName ?? this.deviceName,
      deviceModel: deviceModel ?? this.deviceModel,
      osType: osType ?? this.osType,
      osVersion: osVersion ?? this.osVersion,
      appVersion: appVersion ?? this.appVersion,
      isActive: isActive ?? this.isActive,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      lastIpAddress: lastIpAddress ?? this.lastIpAddress,
      fcmToken: fcmToken ?? this.fcmToken,
      fcmTokenUpdatedAt: fcmTokenUpdatedAt ?? this.fcmTokenUpdatedAt,
      isNotificationsEnabled:
          isNotificationsEnabled ?? this.isNotificationsEnabled,
      loginAttempts: loginAttempts ?? this.loginAttempts,
      isLocked: isLocked ?? this.isLocked,
      lockedUntil: lockedUntil ?? this.lockedUntil,
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
