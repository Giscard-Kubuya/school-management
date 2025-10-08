import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:school_management_app/core/errors/exceptions.dart';
import 'package:school_management_app/core/errors/failures.dart';
import 'package:school_management_app/core/errors/unauthorized_failure.dart';
import 'package:school_management_app/core/network/network_info.dart';
import 'package:school_management_app/features/device_config/data/datasources/device_config_remote_data_source.dart';
import 'package:school_management_app/features/device_config/data/datasources/device_info_service.dart';
import 'package:school_management_app/features/device_config/data/datasources/device_local_data_source.dart';
import 'package:school_management_app/features/device_config/domain/entities/device_info.dart';
import 'package:school_management_app/features/device_config/domain/entities/university.dart';
import 'package:school_management_app/features/device_config/domain/failures/device_failure.dart';
import 'package:school_management_app/core/data/models/device_auth/device_configuration_model.dart';
import 'package:school_management_app/features/device_config/domain/repositories/device_config_repository.dart';

class DeviceConfigRepositoryImpl implements DeviceConfigRepository {
  final DeviceConfigRemoteDataSource remoteDataSource;
  final DeviceLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final DeviceInfoService deviceInfoService;

  DeviceConfigRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.deviceInfoService,
  });

  @override
  Future<Either<Failure, List<University>>> getUniversities() async {
    print("fetching data university....................");
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      // First try to get from remote
      final universitiesData = await remoteDataSource.getUniversities();

      // Convert List<Map<String, dynamic>> to List<University>
      final universities = universitiesData
          .map(
            (universityMap) => University(
              id: universityMap['id']?.toString() ?? '',
              name: universityMap['name']?.toString() ?? 'Unknown University',
              country: universityMap['country']?.toString(),
              logoUrl: universityMap['logoUrl']?.toString(),
            ),
          )
          .toList();

      // Cache the universities if needed
      // await localDataSource.cacheUniversities(universities);

      return Right(universities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch universities'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> registerDevice(
    Map<String, dynamic> deviceInfo,
  ) async {
    try {
      // First check if device is already registered locally
      final deviceId = await deviceInfoService.getDeviceId();
      final isRegistered = await localDataSource.isDeviceRegistered(deviceId);

      if (isRegistered) {
        final config = await localDataSource.getCachedDeviceConfig();
        if (config != null) {
          // Update last used timestamp
          await localDataSource.updateLastUsed(deviceId);
          return Right({
            'status': 'already_registered',
            'device': config.toJson(),
          });
        }
      }

      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure());
      }

      // Get device info if not provided
      if (!deviceInfo.containsKey('deviceId')) {
        deviceInfo['deviceId'] = deviceId;
      }
      if (!deviceInfo.containsKey('deviceName')) {
        deviceInfo['deviceName'] = await deviceInfoService.getDeviceName();
      }
      if (!deviceInfo.containsKey('deviceType')) {
        deviceInfo['deviceType'] = await deviceInfoService.getDeviceTypeString();
      }

      // Register with remote server
      final response = await remoteDataSource.registerDevice(deviceInfo);

      // Cache the device configuration if registration is successful
      if (response['status'] == 'pending_verification' ||
          response['status'] == 'verified') {
        final config = DeviceConfiguration.fromJson(response['device']);
        await localDataSource.cacheDeviceConfig(config);
      }

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to register device: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyDevice(
    String email,
    String code,
  ) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure());
      }

      // First check if we have a pending registration locally
      final deviceId = await deviceInfoService.getDeviceId();
      final registration = await localDataSource.getRegistrationByCode(code);

      if (registration == null) {
        // No local registration found, try remote verification
        final response = await remoteDataSource.verifyDevice(email, code);

        if (response['status'] == 'verified') {
          // Cache the verified device configuration
          final config = DeviceConfiguration.fromJson(response['device']);
          await localDataSource.cacheDeviceConfig(config);
        }

        return Right(response);
      }

      // Verify with remote server
      final response = await remoteDataSource.verifyDevice(email, code);

      if (response['status'] == 'verified') {
        // Update local cache
        await localDataSource.markRegistrationAsUsed(registration.id);

        // Cache the verified device configuration
        final config = DeviceConfiguration.fromJson(response['device']);
        await localDataSource.cacheDeviceConfig(config);
      }

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to verify device: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> syncData({
    required String universityId,
    required String role,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return Left(NetworkFailure());
      }

      final deviceId = await deviceInfoService.getDeviceId();
      final isRegistered = await localDataSource.isDeviceRegistered(deviceId);

      if (!isRegistered) {
        return Left(UnauthorizedFailure(message: 'Device not registered'));
      }

      // Get the latest data from the server
      final response = await remoteDataSource.syncData(universityId, role);

      // Update last sync timestamp
      await localDataSource.updateLastUsed(deviceId);

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to sync data: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkDeviceRegistrationStatus() async {
    try {
      final deviceId = await deviceInfoService.getDeviceId();
      final isRegistered = await localDataSource.isDeviceRegistered(deviceId);
      return Right(isRegistered);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(
        DeviceFailure(message: 'Failed to check device registration: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> sendVerificationCode({
    required String email,
    required DeviceInfo deviceInfo,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.sendVerificationCode(
        email: email,
        deviceInfo: {
          'university_id': deviceInfo.universityId,
          'uuid': deviceInfo.deviceId,
          'name': deviceInfo.deviceName,
          'type': _getDeviceType(deviceInfo.osName),
          'model': deviceInfo.model ?? deviceInfo.deviceName,
          'os_name': deviceInfo.osName,
          'os_version': deviceInfo.osVersion,
          'app_version': deviceInfo.appVersion,
          'app_build_number': deviceInfo.appBuildNumber ?? '1',
          'app_identifier': deviceInfo.appIdentifier ?? 'com.example.app',
        },
      );
      return Right(response);
    } on ServerException catch (e) {
      print(e);

      return Left(ServerFailure(message: e.message));
    } catch (e) {
      print(e);
      return Left(ServerFailure(message: 'Failed to send verification code'));
    }
  }

  String _getDeviceType(String osName) {
    final osLower = osName.toLowerCase();
    if (osLower.contains('android') || osLower.contains('ios')) {
      return 'mobile';
    } else if (osLower.contains('windows') ||
        osLower.contains('macos') ||
        osLower.contains('linux')) {
      return 'desktop';
    } else if (osLower.contains('web')) {
      return 'web';
    }
    return 'mobile'; // Default to mobile
  }
}
