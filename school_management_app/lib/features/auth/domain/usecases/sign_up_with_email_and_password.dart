// import 'package:dartz/dartz.dart';
// import 'package:school_management_app/core/error/failures.dart';
// import 'package:school_management_app/features/auth/domain/repositories/auth_repository.dart';
// import 'package:school_management_app/features/auth/domain/usecases/usecase.dart';

// class SignUpWithEmailAndPassword implements UseCase<void, SignUpParams> {
//   final AuthRepository repository;

//   SignUpWithEmailAndPassword(this.repository);

//   @override
//   Future<Either<Failure, void>> call(SignUpParams params) async {
//     return await repository.signUpWithEmailAndPassword(
//       email: params.email,
//       password: params.password,
//       name: params.name,
//     );
//   }
// }

// class SignUpParams {
//   final String email;
//   final String password;
//   final String name;

//   SignUpParams({
//     required this.email,
//     required this.password,
//     required this.name,
//   });
// }
