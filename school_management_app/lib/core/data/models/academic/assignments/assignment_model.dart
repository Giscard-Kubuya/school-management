import 'package:flutter/foundation.dart';
import '../../base_model.dart';

enum AssignmentType { homework, quiz, project, exam, essay, presentation }

@immutable
class Assignment extends BaseModel {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final AssignmentType type;
  final DateTime dueDate;
  final int? maxScore;
  final double? weight;
  final String? instructions;
  final String? submissionFormat;
  final bool isGroupAssignment;
  final bool isPublished;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Assignment({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.type,
    required this.dueDate,
    this.maxScore,
    this.weight,
    this.instructions,
    this.submissionFormat,
    this.isGroupAssignment = false,
    this.isPublished = false,
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
    title,
    description,
    type,
    dueDate,
    maxScore,
    weight,
    instructions,
    submissionFormat,
    isGroupAssignment,
    isPublished,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: AssignmentType.values.firstWhere(
        (e) => e.toString() == 'AssignmentType.${json['type']}',
        orElse: () => AssignmentType.homework,
      ),
      dueDate: DateTime.parse(json['dueDate'] as String),
      maxScore: json['maxScore'] as int?,
      weight: (json['weight'] as num?)?.toDouble(),
      instructions: json['instructions'] as String?,
      submissionFormat: json['submissionFormat'] as String?,
      isGroupAssignment: json['isGroupAssignment'] as bool? ?? false,
      isPublished: json['isPublished'] as bool? ?? false,
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
      'title': title,
      if (description != null) 'description': description,
      'type': type.toString().split('.').last,
      'dueDate': dueDate.toIso8601String(),
      if (maxScore != null) 'maxScore': maxScore,
      if (weight != null) 'weight': weight,
      if (instructions != null) 'instructions': instructions,
      if (submissionFormat != null) 'submissionFormat': submissionFormat,
      'isGroupAssignment': isGroupAssignment,
      'isPublished': isPublished,
      'syncStatus': syncStatus,
      'syncVersion': syncVersion,
      'isDirty': isDirty,
      if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt!.toIso8601String(),
      if (conflictData != null) 'conflictData': conflictData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Assignment copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    AssignmentType? type,
    DateTime? dueDate,
    int? maxScore,
    double? weight,
    String? instructions,
    String? submissionFormat,
    bool? isGroupAssignment,
    bool? isPublished,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Assignment(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      dueDate: dueDate ?? this.dueDate,
      maxScore: maxScore ?? this.maxScore,
      weight: weight ?? this.weight,
      instructions: instructions ?? this.instructions,
      submissionFormat: submissionFormat ?? this.submissionFormat,
      isGroupAssignment: isGroupAssignment ?? this.isGroupAssignment,
      isPublished: isPublished ?? this.isPublished,
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
