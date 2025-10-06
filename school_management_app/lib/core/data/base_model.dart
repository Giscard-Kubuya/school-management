import 'package:equatable/equatable.dart';

/// A base model interface that all domain models should implement.
/// Provides common functionality like ID and sync status tracking.
abstract class BaseModel extends Equatable {
  /// Unique identifier for the model
  final String id;

  /// Sync status of the model (e.g., 'synced', 'pending', 'error')
  final String syncStatus;

  /// Version number for optimistic concurrency control
  final int syncVersion;

  /// Whether the model has local changes that need to be synced
  final bool isDirty;

  /// Timestamp of the last successful sync
  final DateTime? lastSyncedAt;

  /// Conflict data if there was a sync conflict
  final Map<String, dynamic>? conflictData;

  /// Timestamp when the model was created
  final DateTime createdAt;

  /// Timestamp when the model was last updated
  final DateTime updatedAt;

  const BaseModel({
    required this.id,
    this.syncStatus = 'synced',
    this.syncVersion = 1,
    this.isDirty = false,
    this.lastSyncedAt,
    this.conflictData,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Creates a copy of the model with the given fields replaced with the new values
  BaseModel copyWith({
    String? id,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? updatedAt,
  });

  /// Converts the model to a JSON map
  Map<String, dynamic> toJson();

  @override
  List<Object?> get props => [
    id,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  @override
  bool? get stringify => true;
}
