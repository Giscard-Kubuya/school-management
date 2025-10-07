import 'package:school_management_app/core/network/api_client.dart';
import 'package:school_management_app/core/errors/exceptions.dart';
import 'package:school_management_app/core/constants/api_constants.dart';
import 'package:school_management_app/core/constants/app_constants.dart';

abstract class DeviceConfigRemoteDataSource {
  Future<Map<String, dynamic>> registerDevice(Map<String, dynamic> deviceInfo);
  Future<List<Map<String, dynamic>>> getUniversities();
  Future<Map<String, dynamic>> verifyDevice(String email, String code);
  Future<Map<String, dynamic>> syncData(String universityId, String role);
}

class DeviceConfigRemoteDataSourceImpl implements DeviceConfigRemoteDataSource {
  final ApiClient _apiClient;

  DeviceConfigRemoteDataSourceImpl({required ApiClient apiClient}) 
      : _apiClient = apiClient;

  @override
  Future<Map<String, dynamic>> registerDevice(Map<String, dynamic> deviceInfo) async {
    try {
      final response = await _apiClient.post(
        '${AppConstants.baseUrl}/devices/register',
        data: deviceInfo,
      );
      return response;
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Failed to register device');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUniversities() async {
    try {
      final response = await _apiClient.get(
        '${AppConstants.baseUrl}${ApiConstants.universities}',
      );
      return List<Map<String, dynamic>>.from(response['data'] ?? []);
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Failed to fetch universities');
    }
  }

  @override
  Future<Map<String, dynamic>> verifyDevice(String email, String code) async {
    try {
      final response = await _apiClient.post(
        '${AppConstants.baseUrl}/devices/verify',
        data: {'email': email, 'code': code},
      );
      return response;
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Failed to verify device');
    }
  }

  @override
  Future<Map<String, dynamic>> syncData(String universityId, String role) async {
    try {
      final response = await _apiClient.post(
        '${AppConstants.baseUrl}${ApiConstants.sync}',
        data: {
          'university_id': universityId, 
          'role': role,
        },
      );
      return response;
    } on ServerException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Failed to sync data');
    }
  }
}
