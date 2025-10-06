import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class CoursePrerequisite extends BaseModel {
  final String id;
  final String courseId;
  final String prerequisiteCourseId;
  final bool isMandatory;
  final double? minimumGrade;
  final String? notes;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CoursePrerequisite({
    required this.id,
    required this.courseId,
    required this.prerequisiteCourseId,
    this.isMandatory = true,
    this.minimumGrade,
    this.notes,
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
    prerequisiteCourseId,
    isMandatory,
    minimumGrade,
    notes,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory CoursePrerequisite.fromJson(Map<String, dynamic> json) {
    return CoursePrerequisite(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      prerequisiteCourseId: json['prerequisiteCourseId'] as String,
      isMandatory: json['isMandatory'] as bool? ?? true,
      minimumGrade: (json['minimumGrade'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
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
      'prerequisiteCourseId': prerequisiteCourseId,
      'isMandatory': isMandatory,
      if (minimumGrade != null) 'minimumGrade': minimumGrade,
      if (notes != null) 'notes': notes,
      'syncStatus': syncStatus,
      'syncVersion': syncVersion,
      'isDirty': isDirty,
      if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt!.toIso8601String(),
      if (conflictData != null) 'conflictData': conflictData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  CoursePrerequisite copyWith({
    String? id,
    String? courseId,
    String? prerequisiteCourseId,
    bool? isMandatory,
    double? minimumGrade,
    String? notes,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CoursePrerequisite(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      prerequisiteCourseId: prerequisiteCourseId ?? this.prerequisiteCourseId,
      isMandatory: isMandatory ?? this.isMandatory,
      minimumGrade: minimumGrade ?? this.minimumGrade,
      notes: notes ?? this.notes,
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
