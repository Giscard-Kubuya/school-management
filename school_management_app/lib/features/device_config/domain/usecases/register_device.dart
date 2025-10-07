import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/device_info.dart';
import '../repositories/device_config_repository.dart';

class RegisterDeviceParams {
  final DeviceInfo deviceInfo;
  final String email;
  final String universityId;
  final String role;

  RegisterDeviceParams({
    required this.deviceInfo,
    required this.email,
    required this.universityId,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      ...deviceInfo.toJson(),
      'email': email,
      'university_id': universityId,
      'role': role,
    };
  }
}

class RegisterDevice implements UseCase<Map<String, dynamic>, RegisterDeviceParams> {
  final DeviceConfigRepository repository;

  RegisterDevice(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(RegisterDeviceParams params) async {
    return await repository.registerDevice(params.toJson());
  }
}
