import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class CourseOffering extends BaseModel {
  final String id;
  final String courseId;
  final String? instructorId;
  final String? semesterId;
  final String? academicYearId;
  final int maxEnrollment;
  final int currentEnrollment;
  final String? location;
  final String? schedule;
  final bool isActive;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CourseOffering({
    required this.id,
    required this.courseId,
    this.instructorId,
    this.semesterId,
    this.academicYearId,
    this.maxEnrollment = 30,
    this.currentEnrollment = 0,
    this.location,
    this.schedule,
    this.isActive = true,
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
    courseId,
    instructorId,
    semesterId,
    academicYearId,
    maxEnrollment,
    currentEnrollment,
    location,
    schedule,
    isActive,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory CourseOffering.fromJson(Map<String, dynamic> json) {
    return CourseOffering(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      instructorId: json['instructorId'] as String?,
      semesterId: json['semesterId'] as String?,
      academicYearId: json['academicYearId'] as String?,
      maxEnrollment: json['maxEnrollment'] as int? ?? 30,
      currentEnrollment: json['currentEnrollment'] as int? ?? 0,
      location: json['location'] as String?,
      schedule: json['schedule'] as String?,
      isActive: json['isActive'] as bool? ?? true,
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
      'courseId': courseId,
      if (instructorId != null) 'instructorId': instructorId,
      if (semesterId != null) 'semesterId': semesterId,
      if (academicYearId != null) 'academicYearId': academicYearId,
      'maxEnrollment': maxEnrollment,
      'currentEnrollment': currentEnrollment,
      if (location != null) 'location': location,
      if (schedule != null) 'schedule': schedule,
      'isActive': isActive,
      'syncStatus': syncStatus,
      'syncVersion': syncVersion,
      'isDirty': isDirty,
      if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt!.toIso8601String(),
      if (conflictData != null) 'conflictData': conflictData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  CourseOffering copyWith({
    String? id,
    String? courseId,
    String? instructorId,
    String? semesterId,
    String? academicYearId,
    int? maxEnrollment,
    int? currentEnrollment,
    String? location,
    String? schedule,
    bool? isActive,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseOffering(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      instructorId: instructorId ?? this.instructorId,
      semesterId: semesterId ?? this.semesterId,
      academicYearId: academicYearId ?? this.academicYearId,
      maxEnrollment: maxEnrollment ?? this.maxEnrollment,
      currentEnrollment: currentEnrollment ?? this.currentEnrollment,
      location: location ?? this.location,
      schedule: schedule ?? this.schedule,
      isActive: isActive ?? this.isActive,
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
