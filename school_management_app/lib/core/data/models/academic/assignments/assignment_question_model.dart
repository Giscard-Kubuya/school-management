import 'package:flutter/foundation.dart';
import '../../base_model.dart';

enum QuestionType { multiple_choice, true_false, short_answer, essay, matching, fill_blank }

@immutable
class AssignmentQuestion extends BaseModel {
  final String id;
  final String assignmentId;
  final int questionNumber;
  final QuestionType type;
  final String questionText;
  final Map<String, dynamic>? options;
  final String? correctAnswer;
  final double points;
  final String? explanation;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AssignmentQuestion({
    required this.id,
    required this.assignmentId,
    required this.questionNumber,
    required this.type,
    required this.questionText,
    this.options,
    this.correctAnswer,
    this.points = 1.0,
    this.explanation,
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
    questionNumber,
    type,
    questionText,
    options,
    correctAnswer,
    points,
    explanation,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory AssignmentQuestion.fromJson(Map<String, dynamic> json) {
    return AssignmentQuestion(
      id: json['id'] as String,
      assignmentId: json['assignmentId'] as String,
      questionNumber: json['questionNumber'] as int,
      type: QuestionType.values.firstWhere(
        (e) => e.toString() == 'QuestionType.${json['type']}',
        orElse: () => QuestionType.short_answer,
      ),
      questionText: json['questionText'] as String,
      options: json['options'] as Map<String, dynamic>?,
      correctAnswer: json['correctAnswer'] as String?,
      points: (json['points'] as num?)?.toDouble() ?? 1.0,
      explanation: json['explanation'] as String?,
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
      'questionNumber': questionNumber,
      'type': type.toString().split('.').last,
      'questionText': questionText,
      if (options != null) 'options': options,
      if (correctAnswer != null) 'correctAnswer': correctAnswer,
      'points': points,
      if (explanation != null) 'explanation': explanation,
      'syncStatus': syncStatus,
      'syncVersion': syncVersion,
      'isDirty': isDirty,
      if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt!.toIso8601String(),
      if (conflictData != null) 'conflictData': conflictData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  AssignmentQuestion copyWith({
    String? id,
    String? assignmentId,
    int? questionNumber,
    QuestionType? type,
    String? questionText,
    Map<String, dynamic>? options,
    String? correctAnswer,
    double? points,
    String? explanation,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AssignmentQuestion(
      id: id ?? this.id,
      assignmentId: assignmentId ?? this.assignmentId,
      questionNumber: questionNumber ?? this.questionNumber,
      type: type ?? this.type,
      questionText: questionText ?? this.questionText,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      points: points ?? this.points,
      explanation: explanation ?? this.explanation,
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
