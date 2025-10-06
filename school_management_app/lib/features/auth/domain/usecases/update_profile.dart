// import 'package:dartz/dartz.dart';
// import 'package:school_management_app/core/error/failures.dart';
// import 'package:school_management_app/features/auth/domain/entities/user.dart';
// import 'package:school_management_app/features/auth/domain/repositories/auth_repository.dart';

// class UpdateProfileParams {
//   final String? name;
//   final String? photoUrl;

//   const UpdateProfileParams({
//     this.name,
//     this.photoUrl,
//   });
// }

// class UpdateProfile {
//   final AuthRepository repository;

//   UpdateProfile(this.repository);

//   Future<Either<Failure, User>> call(UpdateProfileParams params) async {
//     return await repository.updateProfile(
//       name: params.name,
//       photoUrl: params.photoUrl,
//     );
//   }
// }
