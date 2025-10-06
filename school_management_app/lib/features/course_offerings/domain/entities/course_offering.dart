import 'package:equatable/equatable.dart';

class CourseOffering extends Equatable {
  final String id;
  final String courseId;
  final String semesterId;
  final String section;
  final int capacity;
  final int enrolledCount;
  final bool isActive;
  final DateTime? registrationStartDate;
  final DateTime? registrationEndDate;
  final DateTime? withdrawalDeadline;

  const CourseOffering({
    required this.id,
    required this.courseId,
    required this.semesterId,
    required this.section,
    required this.capacity,
    this.enrolledCount = 0,
    this.isActive = true,
    this.registrationStartDate,
    this.registrationEndDate,
    this.withdrawalDeadline,
  });

  @override
  List<Object?> get props => [
        id,
        courseId,
        semesterId,
        section,
        capacity,
        enrolledCount,
        isActive,
        registrationStartDate,
        registrationEndDate,
        withdrawalDeadline,
      ];

  CourseOffering copyWith({
    String? id,
    String? courseId,
    String? semesterId,
    String? section,
    int? capacity,
    int? enrolledCount,
    bool? isActive,
    DateTime? registrationStartDate,
    DateTime? registrationEndDate,
    DateTime? withdrawalDeadline,
  }) {
    return CourseOffering(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      semesterId: semesterId ?? this.semesterId,
      section: section ?? this.section,
      capacity: capacity ?? this.capacity,
      enrolledCount: enrolledCount ?? this.enrolledCount,
      isActive: isActive ?? this.isActive,
      registrationStartDate: registrationStartDate ?? this.registrationStartDate,
      registrationEndDate: registrationEndDate ?? this.registrationEndDate,
      withdrawalDeadline: withdrawalDeadline ?? this.withdrawalDeadline,
    );
  }
}
