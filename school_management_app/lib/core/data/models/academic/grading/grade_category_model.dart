import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class GradeCategory extends BaseModel {
  final String id;
  final String name;
  final String? description;
  final double weight;
  final int? dropLowest;
  final int? itemCount;
  final String? courseId;
  final bool isActive;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GradeCategory({
    required this.id,
    required this.name,
    this.description,
    required this.weight,
    this.dropLowest,
    this.itemCount,
    this.courseId,
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
    name,
    description,
    weight,
    dropLowest,
    itemCount,
    courseId,
    isActive,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory GradeCategory.fromJson(Map<String, dynamic> json) {
    return GradeCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      weight: (json['weight'] as num).toDouble(),
      dropLowest: json['dropLowest'] as int?,
      itemCount: json['itemCount'] as int?,
      courseId: json['courseId'] as String?,
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
      'name': name,
      if (description != null) 'description': description,
      'weight': weight,
      if (dropLowest != null) 'dropLowest': dropLowest,
      if (itemCount != null) 'itemCount': itemCount,
      if (courseId != null) 'courseId': courseId,
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

  GradeCategory copyWith({
    String? id,
    String? name,
    String? description,
    double? weight,
    int? dropLowest,
    int? itemCount,
    String? courseId,
    bool? isActive,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GradeCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      weight: weight ?? this.weight,
      dropLowest: dropLowest ?? this.dropLowest,
      itemCount: itemCount ?? this.itemCount,
      courseId: courseId ?? this.courseId,
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
