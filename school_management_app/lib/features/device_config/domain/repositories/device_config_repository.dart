import 'package:dartz/dartz.dart';
import 'package:school_management_app/core/errors/failures.dart';
import '../entities/university.dart';

abstract class DeviceConfigRepository {
  /// Fetches the list of available universities
  Future<Either<Failure, List<University>>> getUniversities();
  
  /// Registers a new device with the server
  /// 
  /// [deviceInfo] - Device information to be registered
  Future<Either<Failure, Map<String, dynamic>>> registerDevice(Map<String, dynamic> deviceInfo);
  
  /// Verifies the device using the provided code
  /// 
  /// [email] - The email address used for registration
  /// [code] - The verification code received by the user
  Future<Either<Failure, Map<String, dynamic>>> verifyDevice(String email, String code);
  
  /// Synchronizes data with the server
  /// 
  /// [universityId] - The ID of the selected university
  /// [role] - The user's role (student, teacher, etc.)
  Future<Either<Failure, Map<String, dynamic>>> syncData({
    required String universityId,
    required String role,
  });
}
