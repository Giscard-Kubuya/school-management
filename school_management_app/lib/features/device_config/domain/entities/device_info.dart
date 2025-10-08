class DeviceInfo {
  final String deviceId;
  final String deviceName;
  final String osName;
  final String osVersion;
  final String appVersion;
  final String? model;
  final String? manufacturer;
  final String? appBuildNumber;
  final String? appIdentifier;
  final String? universityId;

  const DeviceInfo({
    required this.deviceId,
    required this.deviceName,
    required this.osName,
    required this.osVersion,
    required this.appVersion,
    this.model,
    this.manufacturer,
    this.appBuildNumber,
    this.appIdentifier,
    this.universityId,
  });

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'device_name': deviceName,
      'os_name': osName,
      'os_version': osVersion,
      'app_version': appVersion,
      'model': model,
      'manufacturer': manufacturer,
      'app_build_number': appBuildNumber,
      'app_identifier': appIdentifier,
      'university_id': universityId,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is DeviceInfo &&
      other.deviceId == deviceId &&
      other.deviceName == deviceName &&
      other.osName == osName &&
      other.osVersion == osVersion;
  }

  @override
  int get hashCode {
    return deviceId.hashCode ^
      deviceName.hashCode ^
      osName.hashCode ^
      osVersion.hashCode;
  }
}
