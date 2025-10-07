import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_management_app/core/errors/exceptions.dart';
import 'package:school_management_app/core/errors/failures.dart';
import 'package:school_management_app/core/network/network_info.dart';
import 'package:school_management_app/core/constants/storage_keys.dart';
import 'package:school_management_app/core/constants/app_constants.dart';
import 'package:school_management_app/features/device_config/data/datasources/device_config_remote_data_source.dart';
import 'package:school_management_app/features/device_config/domain/repositories/device_config_repository.dart';

class DeviceConfigRepositoryImpl implements DeviceConfigRepository {
  final DeviceConfigRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;

  DeviceConfigRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getUniversities() async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final universities = await remoteDataSource.getUniversities();
      return Right(universities);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch universities'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> registerDevice(
      Map<String, dynamic> deviceInfo) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.registerDevice(deviceInfo);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to register device'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyDevice(
      String email, String code) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.verifyDevice(email, code);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to verify device'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> syncData({
    required String universityId,
    required String role,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(NetworkFailure());
    }

    try {
      final response = await remoteDataSource.syncData(universityId, role);
      
      // Save device configuration to local storage
      await _saveDeviceConfig(universityId, role);
      
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to sync data'));
    }
  }
  
  /// Saves the device configuration to local storage
  Future<void> _saveDeviceConfig(String universityId, String role) async {
    try {
      await Future.wait([
        sharedPreferences.setString(StorageKeys.selectedUniversityId, universityId),
        sharedPreferences.setString(StorageKeys.userData, role),
        sharedPreferences.setBool(AppConstants.isDeviceConfiguredKey, true),
      ]);
    } catch (e) {
      throw CacheException(message: 'Failed to save device configuration');
    }
  }
}
