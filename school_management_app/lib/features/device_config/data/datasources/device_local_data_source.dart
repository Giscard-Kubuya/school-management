import 'dart:async';
import 'package:school_management_app/core/data/models/device_auth/device_configuration_model.dart';
import 'package:school_management_app/core/data/models/device_auth/device_registration_model.dart';

/// Abstract class defining the contract for device local data operations
abstract class DeviceLocalDataSource {
  /// Caches the device configuration
  Future<void> cacheDeviceConfig(DeviceConfiguration config);
  
  /// Retrieves the cached device configuration
  Future<DeviceConfiguration?> getCachedDeviceConfig();
  
  /// Checks if a device is registered
  Future<bool> isDeviceRegistered(String deviceId);
  
  /// Updates the last used timestamp for a device
  Future<void> updateLastUsed(String deviceId);
  
  /// Deactivates a device
  Future<void> deactivateDevice(String deviceId);

  // Device Registration
  /// Caches a device registration
  Future<void> cacheRegistration(DeviceRegistration registration);
  
  /// Gets a pending registration for a device
  Future<DeviceRegistration?> getPendingRegistration(String deviceId);
  
  /// Gets a registration by its code
  Future<DeviceRegistration?> getRegistrationByCode(String code);
  
  /// Marks a registration as used
  Future<void> markRegistrationAsUsed(String registrationId);
  
  /// Updates the FCM token for a device
  Future<void> updateFcmToken(String deviceId, String fcmToken);
  
  /// Updates the last login information for a device
  Future<void> updateLastLogin(String deviceId, String ipAddress);
  
  /// Increments the failed login attempts counter for a device
  Future<void> incrementFailedLoginAttempts(String deviceId);
  
  /// Locks a device for a specified duration
  Future<void> lockDevice(String deviceId, Duration lockDuration);
  
  /// Sets the verification status for a device
  Future<void> setVerificationStatus({
    required String deviceId, 
    required String status, 
    String? verificationCode,
    DateTime? expiresAt,
  });
  
  /// Gets the verification status for a device
  Future<Map<String, dynamic>?> getVerificationStatus(String deviceId);
  
  /// Checks if a device needs verification
  Future<bool> needsVerification(String deviceId);
}
