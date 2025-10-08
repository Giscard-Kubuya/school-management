import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:school_management_app/core/utils/logger.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<Map<String, String>> getDeviceInfo() async {
    final deviceData = <String, String>{};
    final packageInfo = await PackageInfo.fromPlatform();

    try {
      // Get device ID first as it's a required field
      final deviceId = await getDeviceId();
      deviceData['deviceId'] = deviceId;

      if (Platform.isWindows) {
        final windowsInfo = await _deviceInfo.windowsInfo;

        deviceData['deviceName'] = windowsInfo.computerName;
        deviceData['osName'] = 'Windows';
        deviceData['osVersion'] =
            '${windowsInfo.releaseId} (Build ${windowsInfo.buildNumber})';
        deviceData['model'] = windowsInfo.computerName;
        deviceData['manufacturer'] = 'Microsoft';
        deviceData['deviceType'] = 'windows';

        if (windowsInfo.systemMemoryInMegabytes != null) {
          deviceData['memory'] =
              '${(windowsInfo.systemMemoryInMegabytes! / 1024).toStringAsFixed(1)} GB RAM';
        }
        if (windowsInfo.numberOfCores != null) {
          deviceData['cpu'] = '${windowsInfo.numberOfCores} cores';
        }
      } else {
        final deviceInfo = await _deviceInfo.deviceInfo;
        final data = deviceInfo.data;

        // Map common fields
        deviceData['deviceName'] = data['name']?.toString() ?? 'Unknown Device';
        deviceData['osName'] = Platform.operatingSystem;
        deviceData['osVersion'] =
            data['version']?.toString() ?? Platform.operatingSystemVersion;
        deviceData['model'] = data['model']?.toString() ?? 'Unknown';
        deviceData['manufacturer'] =
            data['manufacturer']?.toString() ?? 'Unknown';
        deviceData['deviceType'] = await getDeviceType();
      }
    } catch (e) {
      'Error getting device info'.logError(error: e);
      // Fallback values
      deviceData['deviceId'] = DateTime.now().millisecondsSinceEpoch.toString();
      deviceData['deviceName'] = 'Unknown Device';
      deviceData['osName'] = Platform.operatingSystem;
      deviceData['model'] = Platform.localHostname;
      deviceData['manufacturer'] = 'Unknown';
      deviceData['deviceType'] = Platform.operatingSystem;
    }

    // Add app version info
    deviceData['appName'] = packageInfo.appName;
    deviceData['packageName'] = packageInfo.packageName;
    deviceData['appVersion'] = '${packageInfo.version}+${packageInfo.buildNumber}';
    deviceData['app_identifier'] = packageInfo.packageName; // Add app identifier

    return deviceData;
  }

  Future<String> getDeviceId() async {
    try {
      if (Platform.isWindows) {
        final windowsInfo = await _deviceInfo.windowsInfo;
        return windowsInfo.deviceId;
      }

      final deviceInfo = await _deviceInfo.deviceInfo;
      final data = deviceInfo.data;
      return data['identifierForVendor']?.toString() ??
          data['androidId']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString();
    } catch (e) {
      'Error getting device ID'.logError(error: e);
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  /// Retrieves the device name
  /// On Windows, returns the computer name
  /// On other platforms, returns the device name or model
  Future<String> getDeviceName() async {
    try {
      if (Platform.isWindows) {
        final windowsInfo = await _deviceInfo.windowsInfo;
        return windowsInfo.computerName;
      }

      final deviceInfo = await _deviceInfo.deviceInfo;
      final data = deviceInfo.data;

      // Try to get the most appropriate name based on platform
      if (Platform.isAndroid) {
        return data['model']?.toString() ?? 'Android Device';
      } else if (Platform.isIOS) {
        return data['name']?.toString() ?? 'iOS Device';
      } else if (Platform.isMacOS) {
        return data['computerName']?.toString() ?? 'Mac';
      } else if (Platform.isLinux) {
        return Platform.localHostname;
      }

      // Fallback to hostname if nothing else is available
      return Platform.localHostname;
    } catch (e) {
      'Error getting device name'.logError(error: e);
      return 'Unknown Device';
    }
  }

  /// Returns the device type as a string (e.g., 'windows', 'android', 'ios', etc.)
  Future<String> getDeviceType() async {
    try {
      if (Platform.isWindows) return 'windows';
      if (Platform.isAndroid) return 'android';
      if (Platform.isIOS) return 'ios';
      if (Platform.isMacOS) return 'macos';
      if (Platform.isLinux) return 'linux';

      // For web and other platforms, try to get more specific info
      final deviceInfo = await _deviceInfo.deviceInfo;
      final data = deviceInfo.data;

      // Try to get the device type from platform properties
      if (data.containsKey('device')) {
        return data['device'].toString().toLowerCase();
      }

      // Fallback to the platform name
      return Platform.operatingSystem.toLowerCase();
    } catch (e) {
      'Error getting device type'.logError(error: e);
      return 'unknown';
    }
  }

  /// Returns the device type as a string (e.g., 'windows', 'android', 'ios', etc.)
  /// This is an alias for getDeviceType() to maintain backward compatibility
  Future<String> getDeviceTypeString() async {
    return await getDeviceType();
  }
}
