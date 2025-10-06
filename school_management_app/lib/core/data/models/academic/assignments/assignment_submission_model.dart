import 'package:flutter/foundation.dart';
import '../../base_model.dart';

enum SubmissionStatus { draft, submitted, late, graded, resubmitted }

@immutable
class AssignmentSubmission extends BaseModel {
  final String id;
  final String assignmentId;
  final String studentId;
  final String? groupId;
  final String? content;
  final double? score;
  final String? grade;
  final String? feedback;
  final SubmissionStatus status;
  final DateTime? submittedAt;
  final DateTime? gradedAt;
  final String? gradedById;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AssignmentSubmission({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    this.groupId,
    this.content,
    this.score,
    this.grade,
    this.feedback,
    this.status = SubmissionStatus.draft,
    this.submittedAt,
    this.gradedAt,
    this.gradedById,
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
    studentId,
    groupId,
    content,
    score,
    grade,
    feedback,
    status,
    submittedAt,
    gradedAt,
    gradedById,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory AssignmentSubmission.fromJson(Map<String, dynamic> json) {
    return AssignmentSubmission(
      id: json['id'] as String,
      assignmentId: json['assignmentId'] as String,
      studentId: json['studentId'] as String,
      groupId: json['groupId'] as String?,
      content: json['content'] as String?,
      score: (json['score'] as num?)?.toDouble(),
      grade: json['grade'] as String?,
      feedback: json['feedback'] as String?,
      status: SubmissionStatus.values.firstWhere(
        (e) => e.toString() == 'SubmissionStatus.${json['status']}',
        orElse: () => SubmissionStatus.draft,
      ),
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'] as String)
          : null,
      gradedAt: json['gradedAt'] != null
          ? DateTime.parse(json['gradedAt'] as String)
          : null,
      gradedById: json['gradedById'] as String?,
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
      'studentId': studentId,
      if (groupId != null) 'groupId': groupId,
      if (content != null) 'content': content,
      if (score != null) 'score': score,
      if (grade != null) 'grade': grade,
      if (feedback != null) 'feedback': feedback,
      'status': status.toString().split('.').last,
      if (submittedAt != null) 'submittedAt': submittedAt!.toIso8601String(),
      if (gradedAt != null) 'gradedAt': gradedAt!.toIso8601String(),
      if (gradedById != null) 'gradedById': gradedById,
      'syncStatus': syncStatus,
      'syncVersion': syncVersion,
      'isDirty': isDirty,
      if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt!.toIso8601String(),
      if (conflictData != null) 'conflictData': conflictData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  AssignmentSubmission copyWith({
    String? id,
    String? assignmentId,
    String? studentId,
    String? groupId,
    String? content,
    double? score,
    String? grade,
    String? feedback,
    SubmissionStatus? status,
    DateTime? submittedAt,
    DateTime? gradedAt,
    String? gradedById,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AssignmentSubmission(
      id: id ?? this.id,
      assignmentId: assignmentId ?? this.assignmentId,
      studentId: studentId ?? this.studentId,
      groupId: groupId ?? this.groupId,
      content: content ?? this.content,
      score: score ?? this.score,
      grade: grade ?? this.grade,
      feedback: feedback ?? this.feedback,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      gradedAt: gradedAt ?? this.gradedAt,
      gradedById: gradedById ?? this.gradedById,
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
