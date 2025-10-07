import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/university.dart';
import '../repositories/device_config_repository.dart';

class GetUniversities implements UseCase<List<University>, NoParams> {
  final DeviceConfigRepository repository;

  GetUniversities(this.repository);

  @override
  Future<Either<Failure, List<University>>> call(NoParams params) async {
    return await repository.getUniversities();
  }
}
