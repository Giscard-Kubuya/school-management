import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class FinancialHistory extends BaseModel {
  final String id;
  final String universityId;
  final String accountId;
  final String? relatedAccountId;
  final String transactionId;
  final String transactionType; // payment, transfer, adjustment, refund, etc.
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final String currency;
  final String? reference;
  final String? description;
  final String? notes;
  final String? createdBy;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FinancialHistory({
    required this.id,
    required this.universityId,
    required this.accountId,
    this.relatedAccountId,
    required this.transactionId,
    required this.transactionType,
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    this.currency = 'USD',
    this.reference,
    this.description,
    this.notes,
    this.createdBy,
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
        accountId,
        relatedAccountId,
        transactionId,
        transactionType,
        amount,
        balanceBefore,
        balanceAfter,
        currency,
        reference,
        description,
        notes,
        createdBy,
        syncStatus,
        syncVersion,
        isDirty,
        lastSyncedAt,
        conflictData,
        createdAt,
        updatedAt,
      ];

  factory FinancialHistory.fromJson(Map<String, dynamic> json) {
    return FinancialHistory(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      accountId: json['account_id'] as String,
      relatedAccountId: json['related_account_id'] as String?,
      transactionId: json['transaction_id'] as String,
      transactionType: json['transaction_type'] as String,
      amount: (json['amount'] as num).toDouble(),
      balanceBefore: (json['balance_before'] as num).toDouble(),
      balanceAfter: (json['balance_after'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      reference: json['reference'] as String?,
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String?,
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
      'account_id': accountId,
      'related_account_id': relatedAccountId,
      'transaction_id': transactionId,
      'transaction_type': transactionType,
      'amount': amount,
      'balance_before': balanceBefore,
      'balance_after': balanceAfter,
      'currency': currency,
      'reference': reference,
      'description': description,
      'notes': notes,
      'created_by': createdBy,
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  FinancialHistory copyWith({
    String? id,
    String? universityId,
    String? accountId,
    String? relatedAccountId,
    String? transactionId,
    String? transactionType,
    double? amount,
    double? balanceBefore,
    double? balanceAfter,
    String? currency,
    String? reference,
    String? description,
    String? notes,
    String? createdBy,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FinancialHistory(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      accountId: accountId ?? this.accountId,
      relatedAccountId: relatedAccountId ?? this.relatedAccountId,
      transactionId: transactionId ?? this.transactionId,
      transactionType: transactionType ?? this.transactionType,
      amount: amount ?? this.amount,
      balanceBefore: balanceBefore ?? this.balanceBefore,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      currency: currency ?? this.currency,
      reference: reference ?? this.reference,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
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
