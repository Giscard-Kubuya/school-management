import 'package:flutter/foundation.dart';
import '../../base_model.dart';

enum EnrollmentStatus { pending, active, completed, dropped, withdrawn }

@immutable
class Enrollment extends BaseModel {
  final String id;
  final String studentId;
  final String courseId;
  final String? grade;
  final double? score;
  final EnrollmentStatus status;
  final String? semesterId;
  final DateTime enrollmentDate;
  final DateTime? completionDate;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Enrollment({
    required this.id,
    required this.studentId,
    required this.courseId,
    this.grade,
    this.score,
    this.status = EnrollmentStatus.pending,
    this.semesterId,
    required this.enrollmentDate,
    this.completionDate,
    this.syncStatus = 'synced',
    this.syncVersion = 1,
    this.isDirty = false,
    this.lastSyncedAt,
    this.conflictData,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    studentId,
    courseId,
    grade,
    score,
    status,
    semesterId,
    enrollmentDate,
    completionDate,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      courseId: json['courseId'] as String,
      grade: json['grade'] as String?,
      score: (json['score'] as num?)?.toDouble(),
      status: EnrollmentStatus.values.firstWhere(
        (e) => e.toString() == 'EnrollmentStatus.${json['status']}',
        orElse: () => EnrollmentStatus.pending,
      ),
      semesterId: json['semesterId'] as String?,
      enrollmentDate: DateTime.parse(json['enrollmentDate'] as String),
      completionDate: json['completionDate'] != null
          ? DateTime.parse(json['completionDate'] as String)
          : null,
      syncStatus: json['syncStatus'] as String? ?? 'synced',
      syncVersion: json['syncVersion'] as int? ?? 1,
      isDirty: json['isDirty'] as bool? ?? false,
      lastSyncedAt: json['lastSyncedAt'] != null
          ? DateTime.parse(json['lastSyncedAt'] as String)
          : null,
      conflictData: json['conflictData'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'courseId': courseId,
      if (grade != null) 'grade': grade,
      if (score != null) 'score': score,
      'status': status.toString().split('.').last,
      if (semesterId != null) 'semesterId': semesterId,
      'enrollmentDate': enrollmentDate.toIso8601String(),
      if (completionDate != null)
        'completionDate': completionDate!.toIso8601String(),
      'syncStatus': syncStatus,
      'syncVersion': syncVersion,
      'isDirty': isDirty,
      if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt!.toIso8601String(),
      if (conflictData != null) 'conflictData': conflictData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Enrollment copyWith({
    String? id,
    String? studentId,
    String? courseId,
    String? grade,
    double? score,
    EnrollmentStatus? status,
    String? semesterId,
    DateTime? enrollmentDate,
    DateTime? completionDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Enrollment(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      courseId: courseId ?? this.courseId,
      grade: grade ?? this.grade,
      score: score ?? this.score,
      status: status ?? this.status,
      semesterId: semesterId ?? this.semesterId,
      enrollmentDate: enrollmentDate ?? this.enrollmentDate,
      completionDate: completionDate ?? this.completionDate,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      isDirty: isDirty ?? this.isDirty,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      conflictData: conflictData ?? this.conflictData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
