import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class GradeScaleItem {
  final String letterGrade;
  final double minPercentage;
  final double? maxPercentage;
  final double gradePoint;
  final String? description;

  const GradeScaleItem({
    required this.letterGrade,
    required this.minPercentage,
    this.maxPercentage,
    required this.gradePoint,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'letterGrade': letterGrade,
      'minPercentage': minPercentage,
      if (maxPercentage != null) 'maxPercentage': maxPercentage,
      'gradePoint': gradePoint,
      if (description != null) 'description': description,
    };
  }

  factory GradeScaleItem.fromJson(Map<String, dynamic> json) {
    return GradeScaleItem(
      letterGrade: json['letterGrade'] as String,
      minPercentage: (json['minPercentage'] as num).toDouble(),
      maxPercentage: (json['maxPercentage'] as num?)?.toDouble(),
      gradePoint: (json['gradePoint'] as num).toDouble(),
      description: json['description'] as String?,
    );
  }
}

@immutable
class GradeScale extends BaseModel {
  final String id;
  final String name;
  final String? description;
  final bool isDefault;
  final bool isActive;
  final List<GradeScaleItem> scaleItems;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GradeScale({
    required this.id,
    required this.name,
    this.description,
    this.isDefault = false,
    this.isActive = true,
    required this.scaleItems,
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
    isDefault,
    isActive,
    scaleItems,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory GradeScale.fromJson(Map<String, dynamic> json) {
    return GradeScale(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      scaleItems: (json['scaleItems'] as List)
          .map((item) => GradeScaleItem.fromJson(item as Map<String, dynamic>))
          .toList(),
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
      'isDefault': isDefault,
      'isActive': isActive,
      'scaleItems': scaleItems.map((item) => item.toJson()).toList(),
      'syncStatus': syncStatus,
      'syncVersion': syncVersion,
      'isDirty': isDirty,
      if (lastSyncedAt != null) 'lastSyncedAt': lastSyncedAt!.toIso8601String(),
      if (conflictData != null) 'conflictData': conflictData,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  GradeScale copyWith({
    String? id,
    String? name,
    String? description,
    bool? isDefault,
    bool? isActive,
    List<GradeScaleItem>? scaleItems,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return GradeScale(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      scaleItems: scaleItems ?? this.scaleItems,
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
