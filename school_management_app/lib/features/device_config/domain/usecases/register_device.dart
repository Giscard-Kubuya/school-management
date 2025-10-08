import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:school_management_app/core/errors/failures.dart';
import 'package:school_management_app/core/network/network_info.dart';
import 'package:school_management_app/core/usecases/usecase.dart';
import 'package:school_management_app/features/device_config/domain/entities/device_info.dart';
import 'package:school_management_app/features/device_config/domain/repositories/device_config_repository.dart';

/// Parameters required for device registration
class RegisterDeviceParams {
  final DeviceInfo deviceInfo;
  final String email;
  final String universityId;
  final String role;
  final String? verificationCode;
  final String? deviceId;

  const RegisterDeviceParams({
    required this.deviceInfo,
    required this.email,
    required this.universityId,
    required this.role,
    this.verificationCode,
    this.deviceId,
  });

  /// Converts the parameters to a JSON map for API requests
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'university_id': universityId,
      'role': role,
      'verification_code': verificationCode,
      'device_id': deviceId,
      'device': {
        'uuid': deviceInfo.deviceId,
        'name': deviceInfo.deviceName,
        'type': _mapDeviceType(deviceInfo.osName),
        'model': deviceInfo.model ?? deviceInfo.deviceName,
        'os_name': deviceInfo.osName,
        'os_version': deviceInfo.osVersion,
        'app_version': deviceInfo.appVersion,
        'app_build_number': '1', // Default build number
      },
    };
  }

  /// Maps the device type to the expected API values
  static String _mapDeviceType(String deviceType) {
    const typeMap = {
      'android': 'mobile',
      'ios': 'mobile',
      'windows': 'desktop',
      'macos': 'desktop',
      'linux': 'desktop',
      'web': 'web',
    };
    return typeMap[deviceType.toLowerCase()] ?? 'mobile';
  }

  /// Validates the parameters before making the API call
  Either<Failure, void> validate() {
    if (email.isEmpty || !email.contains('@')) {
      return Left(ValidationFailure(message: 'Please enter a valid email address'));
    }
    if (universityId.isEmpty) {
      return Left(ValidationFailure(message: 'University ID is required'));
    }
    if (role.isEmpty) {
      return Left(ValidationFailure(message: 'Role is required'));
    }
    if (verificationCode != null && verificationCode!.length != 6) {
      return Left(ValidationFailure(message: 'Verification code must be 6 digits'));
    }
    return const Right(null);
  }
}

/// Use case for registering a new device with the server
class RegisterDevice implements UseCase<Map<String, dynamic>, RegisterDeviceParams> {
  final DeviceConfigRepository repository;
  final NetworkInfo networkInfo;

  RegisterDevice(this.repository, {NetworkInfo? networkInfo})
      : networkInfo = networkInfo ?? NetworkInfo(Connectivity());

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(RegisterDeviceParams params) async {
    // Validate parameters
    final validationResult = params.validate();
    if (validationResult.isLeft()) {
      return validationResult as Left<Failure, Map<String, dynamic>>;
    }

    // Check network connectivity
    final isConnected = await networkInfo.isConnected;
    if (!isConnected) {
      return Left(NetworkFailure());
    }

    try {
      // Call the repository to register the device
      return await repository.registerDevice(params.toJson());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
