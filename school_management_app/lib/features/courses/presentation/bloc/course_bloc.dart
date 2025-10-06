// import 'dart:async';
// import 'package:bloc/bloc.dart';
// import 'package:school_management_app/core/error/failures.dart';
// import 'package:school_management_app/core/strings/failures.dart';
// import 'package:school_management_app/features/courses/domain/usecases/create_course_usecase.dart';
// import 'package:school_management_app/features/courses/domain/usecases/delete_course_usecase.dart';
// import 'package:school_management_app/features/courses/domain/usecases/enroll_course_usecase.dart';
// import 'package:school_management_app/features/courses/domain/usecases/get_course_details_usecase.dart';
// import 'package:school_management_app/features/courses/domain/usecases/get_courses_usecase.dart';
// import 'package:school_management_app/features/courses/domain/usecases/update_course_usecase.dart';
// import 'package:school_management_app/features/courses/domain/usecases/get_enrolled_courses_usecase.dart';
// import 'package:school_management_app/features/courses/presentation/bloc/course_event.dart';
// import 'package:school_management_app/features/courses/presentation/bloc/course_state.dart';

// class CourseBloc extends Bloc<CourseEvent, CourseState> {
//   final GetCourses getCourses;
//   final GetCourseDetails getCourseDetails;
//   final CreateCourse createCourse;
//   final UpdateCourse updateCourse;
//   final DeleteCourse deleteCourse;
//   final EnrollInCourse enrollInCourse;
//   final GetEnrolledCourses getEnrolledCourses;

//   CourseBloc({
//     required this.getCourses,
//     required this.getCourseDetails,
//     required this.createCourse,
//     required this.updateCourse,
//     required this.deleteCourse,
//     required this.enrollInCourse,
//     required this.getEnrolledCourses,
//   }) : super(CourseInitial()) {
//     on<LoadCourses>(_onLoadCourses);
//     on<LoadCourseDetails>(_onLoadCourseDetails);
//     on<CreateCourseEvent>(_onCreateCourse);
//     on<UpdateCourseEvent>(_onUpdateCourse);
//     on<DeleteCourseEvent>(_onDeleteCourse);
//     on<EnrollInCourseEvent>(_onEnrollInCourse);
//     on<LoadEnrolledCourses>(_onLoadEnrolledCourses);
//   }

//   FutureOr<void> _onLoadCourses(
//     LoadCourses event,
//     Emitter<CourseState> emit,
//   ) async {
//     emit(CourseLoading());
//     final failureOrCourses = await getCourses(NoParams());
//     failureOrCourses.fold(
//       (failure) => emit(CourseError(_mapFailureToMessage(failure))),
//       (courses) => emit(CoursesLoaded(courses)),
//     );
//   }

//   FutureOr<void> _onLoadCourseDetails(
//     LoadCourseDetails event,
//     Emitter<CourseState> emit,
//   ) async {
//     emit(CourseLoading());
//     final failureOrCourse = await getCourseDetails(event.courseId);
//     failureOrCourse.fold(
//       (failure) => emit(CourseError(_mapFailureToMessage(failure))),
//       (course) => emit(CourseDetailsLoaded(course)),
//     );
//   }

//   FutureOr<void> _onCreateCourse(
//     CreateCourseEvent event,
//     Emitter<CourseState> emit,
//   ) async {
//     emit(CourseLoading());
//     final failureOrSuccess = await createCourse(event.course);
//     failureOrSuccess.fold(
//       (failure) => emit(CourseError(_mapFailureToMessage(failure))),
//       (_) => emit(const CourseOperationSuccess('Course created successfully')),
//     );
//   }

//   FutureOr<void> _onUpdateCourse(
//     UpdateCourseEvent event,
//     Emitter<CourseState> emit,
//   ) async {
//     emit(CourseLoading());
//     final failureOrSuccess = await updateCourse(event.course);
//     failureOrSuccess.fold(
//       (failure) => emit(CourseError(_mapFailureToMessage(failure))),
//       (_) => emit(const CourseOperationSuccess('Course updated successfully')),
//     );
//   }

//   FutureOr<void> _onDeleteCourse(
//     DeleteCourseEvent event,
//     Emitter<CourseState> emit,
//   ) async {
//     emit(CourseLoading());
//     final failureOrSuccess = await deleteCourse(event.courseId);
//     failureOrSuccess.fold(
//       (failure) => emit(CourseError(_mapFailureToMessage(failure))),
//       (_) => emit(const CourseOperationSuccess('Course deleted successfully')),
//     );
//   }

//   FutureOr<void> _onEnrollInCourse(
//     EnrollInCourseEvent event,
//     Emitter<CourseState> emit,
//   ) async {
//     emit(CourseLoading());
//     final failureOrSuccess = await enrollInCourse(event.courseId);
//     failureOrSuccess.fold(
//       (failure) => emit(CourseError(_mapFailureToMessage(failure))),
//       (_) => emit(const CourseOperationSuccess('Successfully enrolled in course')),
//     );
//   }

//   FutureOr<void> _onLoadEnrolledCourses(
//     LoadEnrolledCourses event,
//     Emitter<CourseState> emit,
//   ) async {
//     emit(CourseLoading());
//     final failureOrCourses = await getEnrolledCourses(NoParams());
//     failureOrCourses.fold(
//       (failure) => emit(CourseError(_mapFailureToMessage(failure))),
//       (courses) => emit(CoursesLoaded(courses)),
//     );
//   }

//   String _mapFailureToMessage(Failure failure) {
//     switch (failure.runtimeType) {
//       case ServerFailure:
//         return SERVER_FAILURE_MESSAGE;
//       case CacheFailure:
//         return CACHE_FAILURE_MESSAGE;
//       case NetworkFailure:
//         return NETWORK_FAILURE_MESSAGE;
//       default:
//         return 'Unexpected error';
//     }
//   }
// }
