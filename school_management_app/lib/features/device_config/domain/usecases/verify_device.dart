import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/device_config_repository.dart';

class VerifyDeviceParams {
  final String email;
  final String code;

  const VerifyDeviceParams({
    required this.email,
    required this.code,
  });
}

class VerifyDevice implements UseCase<Map<String, dynamic>, VerifyDeviceParams> {
  final DeviceConfigRepository repository;

  VerifyDevice(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(VerifyDeviceParams params) async {
    return await repository.verifyDevice(params.email, params.code);
  }
}
