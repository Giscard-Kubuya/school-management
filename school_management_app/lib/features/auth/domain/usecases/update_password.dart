// import 'package:dartz/dartz.dart';
// import 'package:school_management_app/core/error/failures.dart';
// import 'package:school_management_app/core/usecases/usecase.dart';
// import 'package:school_management_app/features/auth/domain/repositories/auth_repository.dart';

// class UpdatePasswordParams {
//   final String currentPassword;
//   final String newPassword;

//   const UpdatePasswordParams({
//     required this.currentPassword,
//     required this.newPassword,
//   });
// }

// class UpdatePassword implements UseCase<void, UpdatePasswordParams> {
//   final AuthRepository repository;

//   UpdatePassword(this.repository);

//   @override
//   Future<Either<Failure, void>> call(UpdatePasswordParams params) async {
//     return await repository.updatePassword(
//       currentPassword: params.currentPassword,
//       newPassword: params.newPassword,
//     );
//   }
// }
