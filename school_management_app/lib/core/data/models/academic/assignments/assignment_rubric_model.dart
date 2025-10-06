import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class RubricCriterion {
  final String id;
  final String title;
  final String? description;
  final double maxScore;
  final Map<String, String>? levels; // e.g., { 'Excellent': '5', 'Good': '3', 'Poor': '1' }

  const RubricCriterion({
    required this.id,
    required this.title,
    this.description,
    required this.maxScore,
    this.levels,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      if (description != null) 'description': description,
      'maxScore': maxScore,
      if (levels != null) 'levels': levels,
    };
  }

  factory RubricCriterion.fromJson(Map<String, dynamic> json) {
    return RubricCriterion(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      maxScore: (json['maxScore'] as num).toDouble(),
      levels: json['levels'] != null
          ? Map<String, String>.from(json['levels'] as Map)
          : null,
    );
  }
}

@immutable
class AssignmentRubric extends BaseModel {
  final String id;
  final String assignmentId;
  final String title;
  final String? description;
  final List<RubricCriterion> criteria;
  final bool isPublished;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AssignmentRubric({
    required this.id,
    required this.assignmentId,
    required this.title,
    this.description,
    required this.criteria,
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
    assignmentId,
    title,
    description,
    criteria,
    isPublished,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory AssignmentRubric.fromJson(Map<String, dynamic> json) {
    return AssignmentRubric(
      id: json['id'] as String,
      assignmentId: json['assignmentId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      criteria: (json['criteria'] as List)
          .map((item) => RubricCriterion.fromJson(item as Map<String, dynamic>))
          .toList(),
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
      'assignmentId': assignmentId,
      'title': title,
      if (description != null) 'description': description,
      'criteria': criteria.map((c) => c.toJson()).toList(),
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

  AssignmentRubric copyWith({
    String? id,
    String? assignmentId,
    String? title,
    String? description,
    List<RubricCriterion>? criteria,
    bool? isPublished,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AssignmentRubric(
      id: id ?? this.id,
      assignmentId: assignmentId ?? this.assignmentId,
      title: title ?? this.title,
      description: description ?? this.description,
      criteria: criteria ?? this.criteria,
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
