// import 'package:dartz/dartz.dart';
// import 'package:school_management_app/core/error/exceptions.dart';
// import 'package:school_management_app/core/error/failures.dart';
// import 'package:school_management_app/core/network/network_info.dart';
// import 'package:school_management_app/features/courses/data/datasources/course_local_data_source.dart';
// import 'package:school_management_app/features/courses/data/datasources/course_remote_data_source.dart';
// import 'package:school_management_app/features/courses/domain/entities/course.dart';
// import 'package:school_management_app/features/courses/domain/repositories/course_repository.dart';

// class CourseRepositoryImpl implements CourseRepository {
//   final CourseRemoteDataSource remoteDataSource;
//   final CourseLocalDataSource localDataSource;
//   final NetworkInfo networkInfo;

//   CourseRepositoryImpl({
//     required this.remoteDataSource,
//     required this.localDataSource,
//     required this.networkInfo,
//   });

//   @override
//   Future<Either<Failure, List<Course>>> getCourses() async {
//     if (await networkInfo.isConnected) {
//       try {
//         final remoteCourses = await remoteDataSource.getCourses();
//         await localDataSource.cacheCourses(remoteCourses);
//         return Right(remoteCourses);
//       } on ServerException {
//         return Left(ServerFailure());
//       }
//     } else {
//       try {
//         final localCourses = await localDataSource.getCachedCourses();
//         return Right(localCourses);
//       } on CacheException {
//         return Left(CacheFailure());
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, Course>> getCourse(String id) async {
//     if (await networkInfo.isConnected) {
//       try {
//         final remoteCourse = await remoteDataSource.getCourse(id);
//         // Cache the course if needed
//         return Right(remoteCourse);
//       } on ServerException {
//         return Left(ServerFailure());
//       }
//     } else {
//       try {
//         final localCourse = await localDataSource.getCachedCourse(id);
//         return Right(localCourse);
//       } on CacheException {
//         return Left(CacheFailure());
//       }
//     }
//   }

//   @override
//   Future<Either<Failure, Unit>> createCourse(Course course) async {
//     if (await networkInfo.isConnected) {
//       try {
//         await remoteDataSource.createCourse(course);
//         return const Right(unit);
//       } on ServerException {
//         return Left(ServerFailure());
//       }
//     } else {
//       return Left(NetworkFailure());
//     }
//   }

//   @override
//   Future<Either<Failure, Unit>> updateCourse(Course course) async {
//     if (await networkInfo.isConnected) {
//       try {
//         await remoteDataSource.updateCourse(course);
//         return const Right(unit);
//       } on ServerException {
//         return Left(ServerFailure());
//       }
//     } else {
//       return Left(NetworkFailure());
//     }
//   }

//   @override
//   Future<Either<Failure, Unit>> deleteCourse(String id) async {
//     if (await networkInfo.isConnected) {
//       try {
//         await remoteDataSource.deleteCourse(id);
//         return const Right(unit);
//       } on ServerException {
//         return Left(ServerFailure());
//       }
//     } else {
//       return Left(NetworkFailure());
//     }
//   }

//   @override
//   Future<Either<Failure, Unit>> enrollInCourse(String courseId) async {
//     if (await networkInfo.isConnected) {
//       try {
//         await remoteDataSource.enrollInCourse(courseId);
//         return const Right(unit);
//       } on ServerException {
//         return Left(ServerFailure());
//       }
//     } else {
//       return Left(NetworkFailure());
//     }
//   }

//   @override
//   Future<Either<Failure, List<Course>>> getEnrolledCourses() async {
//     if (await networkInfo.isConnected) {
//       try {
//         final courses = await remoteDataSource.getCourses();
//         final enrolledCourses = courses.where((course) => course.isEnrolled).toList();
//         await localDataSource.cacheCourses(courses);
//         return Right(enrolledCourses);
//       } on ServerException {
//         return Left(ServerFailure());
//       }
//     } else {
//       try {
//         final localCourses = await localDataSource.getCachedCourses();
//         final enrolledCourses = localCourses.where((course) => course.isEnrolled).toList();
//         return Right(enrolledCourses);
//       } on CacheException {
//         return Left(CacheFailure());
//       }
//     }
//   }
// }
