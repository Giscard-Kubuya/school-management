// import 'package:dartz/dartz.dart';
// import 'package:school_management_app/core/error/failures.dart';
// import 'package:school_management_app/features/auth/domain/repositories/auth_repository.dart';
// import 'package:school_management_app/features/auth/domain/usecases/usecase.dart';

// class SignInWithEmailAndPassword implements UseCase<void, SignInParams> {
//   final AuthRepository repository;

//   SignInWithEmailAndPassword(this.repository);

//   @override
//   Future<Either<Failure, void>> call(SignInParams params) async {
//     return await repository.signInWithEmailAndPassword(
//       email: params.email,
//       password: params.password,
//     );
//   }
// }

// class SignInParams {
//   final String email;
//   final String password;

//   SignInParams({
//     required this.email,
//     required this.password,
//   });
// }
