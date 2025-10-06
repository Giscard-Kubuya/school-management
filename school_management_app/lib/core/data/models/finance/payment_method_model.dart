import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class PaymentMethod extends BaseModel {
  final String id;
  final String universityId;
  final String name;
  final String code;
  final String? description;
  final String type; // cash, card, bank_transfer, mobile_money, check, other
  final bool isActive;
  final bool requiresProcessing;
  final double? processingFee;
  final String? processingFeeType; // fixed, percentage
  final String? icon;
  final String? color;
  final Map<String, dynamic>? settings;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PaymentMethod({
    required this.id,
    required this.universityId,
    required this.name,
    required this.code,
    this.description,
    required this.type,
    this.isActive = true,
    this.requiresProcessing = false,
    this.processingFee,
    this.processingFeeType,
    this.icon,
    this.color,
    this.settings,
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
        code,
        description,
        type,
        isActive,
        requiresProcessing,
        processingFee,
        processingFeeType,
        icon,
        color,
        settings,
        syncStatus,
        syncVersion,
        isDirty,
        lastSyncedAt,
        conflictData,
        createdAt,
        updatedAt,
      ];

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      isActive: (json['is_active'] as int?) != 0 && (json['is_active'] as bool?) != false,
      requiresProcessing: (json['requires_processing'] as int?) == 1 || (json['requires_processing'] as bool?) == true,
      processingFee: json['processing_fee']?.toDouble(),
      processingFeeType: json['processing_fee_type'] as String?,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
      settings: json['settings'] != null
          ? Map<String, dynamic>.from(json['settings'] as Map)
          : null,
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
      'code': code,
      'description': description,
      'type': type,
      'is_active': isActive ? 1 : 0,
      'requires_processing': requiresProcessing ? 1 : 0,
      'processing_fee': processingFee,
      'processing_fee_type': processingFeeType,
      'icon': icon,
      'color': color,
      'settings': settings,
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  PaymentMethod copyWith({
    String? id,
    String? universityId,
    String? name,
    String? code,
    String? description,
    String? type,
    bool? isActive,
    bool? requiresProcessing,
    double? processingFee,
    String? processingFeeType,
    String? icon,
    String? color,
    Map<String, dynamic>? settings,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      type: type ?? this.type,
      isActive: isActive ?? this.isActive,
      requiresProcessing: requiresProcessing ?? this.requiresProcessing,
      processingFee: processingFee ?? this.processingFee,
      processingFeeType: processingFeeType ?? this.processingFeeType,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      settings: settings ?? this.settings,
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
