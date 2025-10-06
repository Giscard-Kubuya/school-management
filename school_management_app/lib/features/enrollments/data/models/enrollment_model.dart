import 'package:equatable/equatable.dart';
import 'package:school_management_app/features/enrollments/domain/entities/enrollment.dart';

class EnrollmentModel extends Equatable {
  final String id;
  final String courseOfferingId;
  final String studentId;
  final String enrollmentType; // 'regular', 'audit', 'credit'
  final String enrollmentStatus; // 'enrolled', 'waitlisted', 'dropped', 'completed'
  final DateTime enrollmentDate;
  final DateTime? withdrawalDate;
  final String? finalGrade;
  final double? gradePoints;
  final bool isGradePosted;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final String? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EnrollmentModel({
    required this.id,
    required this.courseOfferingId,
    required this.studentId,
    required this.enrollmentType,
    required this.enrollmentStatus,
    required this.enrollmentDate,
    this.withdrawalDate,
    this.finalGrade,
    this.gradePoints,
    this.isGradePosted = false,
    this.syncStatus = 'synced',
    this.syncVersion = 1,
    this.isDirty = false,
    this.lastSyncedAt,
    this.conflictData,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'] as String,
      courseOfferingId: json['course_offering_id'] as String,
      studentId: json['student_id'] as String,
      enrollmentType: json['enrollment_type'] as String,
      enrollmentStatus: json['enrollment_status'] as String,
      enrollmentDate: DateTime.parse(json['enrollment_date'] as String),
      withdrawalDate: json['withdrawal_date'] != null
          ? DateTime.parse(json['withdrawal_date'] as String)
          : null,
      finalGrade: json['final_grade'] as String?,
      gradePoints: (json['grade_points'] as num?)?.toDouble(),
      isGradePosted: json['is_grade_posted'] == 1,
      syncStatus: json['sync_status'] as String? ?? 'synced',
      syncVersion: json['sync_version'] as int? ?? 1,
      isDirty: json['is_dirty'] == 1,
      lastSyncedAt: json['last_synced_at'] != null
          ? DateTime.parse(json['last_synced_at'] as String)
          : null,
      conflictData: json['conflict_data'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_offering_id': courseOfferingId,
      'student_id': studentId,
      'enrollment_type': enrollmentType,
      'enrollment_status': enrollmentStatus,
      'enrollment_date': enrollmentDate.toIso8601String(),
      'withdrawal_date': withdrawalDate?.toIso8601String(),
      'final_grade': finalGrade,
      'grade_points': gradePoints,
      'is_grade_posted': isGradePosted ? 1 : 0,
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Enrollment toEntity() {
    return Enrollment(
      id: id,
      courseOfferingId: courseOfferingId,
      studentId: studentId,
      enrollmentType: enrollmentType,
      enrollmentStatus: enrollmentStatus,
      enrollmentDate: enrollmentDate,
      withdrawalDate: withdrawalDate,
      finalGrade: finalGrade,
      gradePoints: gradePoints,
      isGradePosted: isGradePosted,
    );
  }

  @override
  List<Object?> get props => [
        id,
        courseOfferingId,
        studentId,
        enrollmentType,
        enrollmentStatus,
        enrollmentDate,
        withdrawalDate,
        finalGrade,
        gradePoints,
        isGradePosted,
        syncStatus,
        syncVersion,
        isDirty,
        lastSyncedAt,
        conflictData,
        createdAt,
        updatedAt,
      ];
}
