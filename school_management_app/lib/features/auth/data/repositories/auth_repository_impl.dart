// import 'package:dartz/dartz.dart';
// import 'package:school_management_app/core/error/exceptions.dart';
// import 'package:school_management_app/core/error/failures.dart';
// import 'package:school_management_app/core/network/network_info.dart';
// import 'package:school_management_app/features/auth/data/datasources/auth_local_data_source.dart';
// import 'package:school_management_app/features/auth/data/datasources/auth_remote_data_source.dart';
// import 'package:school_management_app/features/auth/domain/entities/user.dart';
// import 'package:school_management_app/features/auth/domain/repositories/auth_repository.dart';

// class AuthRepositoryImpl implements AuthRepository {
//   final AuthRemoteDataSource remoteDataSource;
//   final AuthLocalDataSource localDataSource;
//   final NetworkInfo networkInfo;

//   AuthRepositoryImpl({
//     required this.remoteDataSource,
//     required this.localDataSource,
//     required this.networkInfo,
//   });

//   @override
//   Future<bool> get isSignedIn async {
//     try {
//       final token = await localDataSource.getCachedAuthToken();
//       return token != null;
//     } on CacheException {
//       return false;
//     }
//   }

//   @override
//   Stream<User> get user => remoteDataSource.user;

//   @override
//   Future<Either<Failure, User>> signInWithEmailAndPassword({
//     required String email,
//     required String password,
//   }) async {
//     if (await networkInfo.isConnected) {
//       try {
//         final user = await remoteDataSource.signInWithEmailAndPassword(
//           email: email,
//           password: password,
//         );
//         await localDataSource.cacheUser(user);
//         return Right(user);
//       } on ServerException catch (e) {
//         return Left(ServerFailure(message: e.message));
//       } on CacheException {
//         return Left(CacheFailure());
//       }
//     } else {
//       return Left(NetworkFailure());
//     }
//   }

//   @override
//   Future<Either<Failure, User>> signUpWithEmailAndPassword({
//     required String email,
//     required String password,
//     required String name,
//   }) async {
//     if (await networkInfo.isConnected) {
//       try {
//         final user = await remoteDataSource.signUpWithEmailAndPassword(
//           email: email,
//           password: password,
//           name: name,
//         );
//         await localDataSource.cacheUser(user);
//         return Right(user);
//       } on ServerException catch (e) {
//         return Left(ServerFailure(message: e.message));
//       } on CacheException {
//         return Left(CacheFailure());
//       }
//     } else {
//       return Left(NetworkFailure());
//     }
//   }

//   @override
//   Future<Either<Failure, User>> signInWithGoogle() async {
//     if (await networkInfo.isConnected) {
//       try {
//         final user = await remoteDataSource.signInWithGoogle();
//         await localDataSource.cacheUser(user);
//         return Right(user);
//       } on ServerException catch (e) {
//         return Left(ServerFailure(message: e.message));
//       } on CacheException {
//         return Left(CacheFailure());
//       }
//     } else {
//       return Left(NetworkFailure());
//     }
//   }

//   @override
//   Future<Either<Failure, void>> signOut() async {
//     try {
//       await remoteDataSource.signOut();
//       await localDataSource.clearCachedUser();
//       await localDataSource.clearAuthToken();
//       return const Right(null);
//     } on ServerException catch (e) {
//       return Left(ServerFailure(message: e.message));
//     } on CacheException {
//       return Left(CacheFailure());
//     }
//   }

//   @override
//   Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
//     if (await networkInfo.isConnected) {
//       try {
//         await remoteDataSource.sendPasswordResetEmail(email);
//         return const Right(null);
//       } on ServerException catch (e) {
//         return Left(ServerFailure(message: e.message));
//       }
//     } else {
//       return Left(NetworkFailure());
//     }
//   }

//   @override
//   Future<Either<Failure, User>> updateProfile({
//     String? name,
//     String? photoUrl,
//   }) async {
//     if (await networkInfo.isConnected) {
//       try {
//         final user = await remoteDataSource.updateProfile(
//           name: name,
//           photoUrl: photoUrl,
//         );
//         await localDataSource.cacheUser(user);
//         return Right(user);
//       } on ServerException catch (e) {
//         return Left(ServerFailure(message: e.message));
//       } on CacheException {
//         return Left(CacheFailure());
//       }
//     } else {
//       return Left(NetworkFailure());
//     }
//   }

//   @override
//   Future<Either<Failure, void>> updatePassword({
//     required String currentPassword,
//     required String newPassword,
//   }) async {
//     if (await networkInfo.isConnected) {
//       try {
//         await remoteDataSource.updatePassword(
//           currentPassword: currentPassword,
//           newPassword: newPassword,
//         );
//         return const Right(null);
//       } on ServerException catch (e) {
//         return Left(ServerFailure(message: e.message));
//       }
//     } else {
//       return Left(NetworkFailure());
//     }
//   }
// }
