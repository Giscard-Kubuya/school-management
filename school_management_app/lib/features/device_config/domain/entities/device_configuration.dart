import 'package:equatable/equatable.dart';

/// Represents device authentication/config data used for registration and caching in the device
class DeviceConfiguration extends Equatable {
  /// Unique identifier for the device
  final String deviceId;
  
  /// Name of the device
  final String deviceName;
  
  /// Type of the device (e.g., 'android', 'ios', 'web')
  final String deviceType;
  
  /// Status of the device registration (e.g., 'pending_verification', 'verified')
  final String status;
  
  /// Timestamp when the device was registered
  final DateTime registeredAt;
  
  /// Timestamp when the device was last used
  final DateTime? lastUsedAt;
  
  /// Optional authentication token if the device is verified
  final String? authToken;
  
  /// User ID associated with this device (if any)
  final String? userId;
  
  /// Email used for device registration
  final String? email;

  const DeviceConfiguration({
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.status,
    required this.registeredAt,
    this.lastUsedAt,
    this.authToken,
    this.userId,
    this.email,
  });

  /// Creates a [DeviceConfiguration] from a JSON map
  factory DeviceConfiguration.fromJson(Map<String, dynamic> json) {
    return DeviceConfiguration(
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      deviceType: json['deviceType'] as String,
      status: json['status'] as String,
      registeredAt: DateTime.parse(json['registeredAt'] as String),
      lastUsedAt: json['lastUsedAt'] != null 
          ? DateTime.parse(json['lastUsedAt'] as String) 
          : null,
      authToken: json['authToken'] as String?,
      userId: json['userId'] as String?,
      email: json['email'] as String?,
    );
  }

  /// Converts this [DeviceConfiguration] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'status': status,
      'registeredAt': registeredAt.toIso8601String(),
      'lastUsedAt': lastUsedAt?.toIso8601String(),
      'authToken': authToken,
      'userId': userId,
      'email': email,
    };
  }

  /// Creates a copy of this [DeviceConfiguration] with the given fields replaced
  DeviceConfiguration copyWith({
    String? deviceId,
    String? deviceName,
    String? deviceType,
    String? status,
    DateTime? registeredAt,
    DateTime? lastUsedAt,
    String? authToken,
    String? userId,
    String? email,
  }) {
    return DeviceConfiguration(
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      deviceType: deviceType ?? this.deviceType,
      status: status ?? this.status,
      registeredAt: registeredAt ?? this.registeredAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      authToken: authToken ?? this.authToken,
      userId: userId ?? this.userId,
      email: email ?? this.email,
    );
  }

  @override
  List<Object?> get props => [
        deviceId,
        deviceName,
        deviceType,
        status,
        registeredAt,
        lastUsedAt,
        authToken,
        userId,
        email,
      ];

  @override
  String toString() => '''
    DeviceConfiguration(
      deviceId: $deviceId,
      deviceName: $deviceName,
      deviceType: $deviceType,
      status: $status,
      registeredAt: $registeredAt,
      lastUsedAt: $lastUsedAt,
      userId: $userId,
      email: $email,
    )
  ''';
}
