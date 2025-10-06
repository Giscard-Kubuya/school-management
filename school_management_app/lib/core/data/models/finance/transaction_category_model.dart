import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class TransactionCategory extends BaseModel {
  final String id;
  final String universityId;
  final String name;
  final String? description;
  final String type; // income, expense, transfer, adjustment
  final String? parentCategoryId;
  final String? icon;
  final String? color;
  final bool isSystem;
  final bool isActive;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TransactionCategory({
    required this.id,
    required this.universityId,
    required this.name,
    this.description,
    required this.type,
    this.parentCategoryId,
    this.icon,
    this.color,
    this.isSystem = false,
    this.isActive = true,
    this.syncStatus = 'synced',
    this.syncVersion = 1,
    this.isDirty = false,
    this.lastSyncedAt,
    this.conflictData,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
          id: id,
          syncStatus: syncStatus,
          syncVersion: syncVersion,
          isDirty: isDirty,
          lastSyncedAt: lastSyncedAt,
          conflictData: conflictData,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  @override
  List<Object?> get props => [
        id,
        universityId,
        name,
        description,
        type,
        parentCategoryId,
        icon,
        color,
        isSystem,
        isActive,
        syncStatus,
        syncVersion,
        isDirty,
        lastSyncedAt,
        conflictData,
        createdAt,
        updatedAt,
      ];

  factory TransactionCategory.fromJson(Map<String, dynamic> json) {
    return TransactionCategory(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      parentCategoryId: json['parent_category_id'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      isSystem: (json['is_system'] as int?) == 1 || (json['is_system'] as bool?) == true,
      isActive: (json['is_active'] as int?) != 0 && (json['is_active'] as bool?) != false,
      syncStatus: json['sync_status'] as String? ?? 'synced',
      syncVersion: (json['sync_version'] as int?) ?? 1,
      isDirty: (json['is_dirty'] as int?) == 1 || (json['is_dirty'] as bool?) == true,
      lastSyncedAt: json['last_synced_at'] != null
          ? DateTime.parse(json['last_synced_at'] as String)
          : null,
      conflictData: json['conflict_data'] != null
          ? Map<String, dynamic>.from(json['conflict_data'] as Map)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'name': name,
      'description': description,
      'type': type,
      'parent_category_id': parentCategoryId,
      'icon': icon,
      'color': color,
      'is_system': isSystem ? 1 : 0,
      'is_active': isActive ? 1 : 0,
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  TransactionCategory copyWith({
    String? id,
    String? universityId,
    String? name,
    String? description,
    String? type,
    String? parentCategoryId,
    String? icon,
    String? color,
    bool? isSystem,
    bool? isActive,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionCategory(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      parentCategoryId: parentCategoryId ?? this.parentCategoryId,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isSystem: isSystem ?? this.isSystem,
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
