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
      if (Platform.isWindows) {
        final windowsInfo = await _deviceInfo.windowsInfo;
        // Default to x64 as most modern Windows systems are 64-bit
        // We'll use this as a fallback if we can't determine the actual architecture
        final architecture = 'x64';
        
        deviceData['device'] = 'Windows PC';
        deviceData['os'] = 'Windows ${windowsInfo.releaseId} (Build ${windowsInfo.buildNumber})';
        deviceData['model'] = windowsInfo.computerName;
        deviceData['manufacturer'] = windowsInfo.deviceId;
        deviceData['architecture'] = architecture;
        if (windowsInfo.systemMemoryInMegabytes != null) {
          deviceData['memory'] = '${(windowsInfo.systemMemoryInMegabytes! / 1024).toStringAsFixed(1)} GB RAM';
        }
        if (windowsInfo.numberOfCores != null) {
          deviceData['cpu'] = '${windowsInfo.numberOfCores} cores';
        }
      } else {
        final deviceInfo = await _deviceInfo.deviceInfo;
        deviceInfo.data.forEach((key, value) {
          deviceData[key] = value?.toString() ?? '';
        });
      }
    } catch (e) {
      'Error getting device info'.logError(error: e);
      // Fallback values
      deviceData['device'] = Platform.operatingSystem;
      deviceData['os'] =
          '${Platform.operatingSystem} ${Platform.operatingSystemVersion}';
      deviceData['model'] = '${Platform.localHostname}';
    }

    // Add app version info
    deviceData['appName'] = packageInfo.appName;
    deviceData['packageName'] = packageInfo.packageName;
    deviceData['version'] = '${packageInfo.version}+${packageInfo.buildNumber}';

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
}
