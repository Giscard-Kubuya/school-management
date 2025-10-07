import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/device_config_repository.dart';

class SyncDataParams {
  final String universityId;
  final String role;

  const SyncDataParams({
    required this.universityId,
    required this.role,
  });
}

class SyncData implements UseCase<Map<String, dynamic>, SyncDataParams> {
  final DeviceConfigRepository repository;

  SyncData(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(SyncDataParams params) async {
    return await repository.syncData(
      universityId: params.universityId,
      role: params.role,
    );
  }
}
