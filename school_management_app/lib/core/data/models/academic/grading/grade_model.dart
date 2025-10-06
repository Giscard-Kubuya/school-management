import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class Grade extends BaseModel {
  final String id;
  final String studentId;
  final String courseId;
  final String? assignmentId;
  final String? gradeCategoryId;
  final double score;
  final double maxScore;
  final double percentage;
  final String? letterGrade;
  final String? comments;
  final bool isExcused;
  final bool isDropped;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Grade({
    required this.id,
    required this.studentId,
    required this.courseId,
    this.assignmentId,
    this.gradeCategoryId,
    required this.score,
    required this.maxScore,
    required this.percentage,
    this.letterGrade,
    this.comments,
    this.isExcused = false,
    this.isDropped = false,
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
    assignmentId,
    gradeCategoryId,
    score,
    maxScore,
    percentage,
    letterGrade,
    comments,
    isExcused,
    isDropped,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      courseId: json['courseId'] as String,
      assignmentId: json['assignmentId'] as String?,
      gradeCategoryId: json['gradeCategoryId'] as String?,
      score: (json['score'] as num).toDouble(),
      maxScore: (json['maxScore'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      letterGrade: json['letterGrade'] as String?,
      comments: json['comments'] as String?,
      isExcused: json['isExcused'] as bool? ?? false,
      isDropped: json['isDropped'] as bool? ?? false,
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
      if (assignmentId != null) 'assignmentId': assignmentId,
      if (gradeCategoryId != null) 'gradeCategoryId': gradeCategoryId,
      'score': score,
      'maxScore': maxScore,
      'percentage': percentage,
      if (letterGrade != null) 'letterGrade': letterGrade,
      if (comments != null) 'comments': comments,
      'isExcused': isExcused,
      'isDropped': isDropped,
      'syncStatus': syncStatus,
      'syncVersion': syncVersion,
      'isDirty': isDirty,
      if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt!.toIso8601String(),
      if (conflictData != null) 'conflictData': conflictData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Grade copyWith({
    String? id,
    String? studentId,
    String? courseId,
    String? assignmentId,
    String? gradeCategoryId,
    double? score,
    double? maxScore,
    double? percentage,
    String? letterGrade,
    String? comments,
    bool? isExcused,
    bool? isDropped,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Grade(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      courseId: courseId ?? this.courseId,
      assignmentId: assignmentId ?? this.assignmentId,
      gradeCategoryId: gradeCategoryId ?? this.gradeCategoryId,
      score: score ?? this.score,
      maxScore: maxScore ?? this.maxScore,
      percentage: percentage ?? this.percentage,
      letterGrade: letterGrade ?? this.letterGrade,
      comments: comments ?? this.comments,
      isExcused: isExcused ?? this.isExcused,
      isDropped: isDropped ?? this.isDropped,
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
