import 'package:flutter/foundation.dart';
import '../base_model.dart';

@immutable
class Transaction extends BaseModel {
  final String id;
  final String universityId;
  final String transactionNumber;
  final String accountId;
  final String? relatedAccountId;
  final String categoryId;
  final String paymentMethodId;
  final double amount;
  final String currency;
  final String type; // credit, debit, transfer, refund, fee, payment, etc.
  final String status; // pending, completed, failed, cancelled, refunded
  final String? reference;
  final String? description;
  final String? notes;
  final String? receiptNumber;
  final DateTime transactionDate;
  final DateTime? postedDate;
  final bool isRecurring;
  final String? recurringId;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Transaction({
    required this.id,
    required this.universityId,
    required this.transactionNumber,
    required this.accountId,
    this.relatedAccountId,
    required this.categoryId,
    required this.paymentMethodId,
    required this.amount,
    this.currency = 'USD',
    required this.type,
    this.status = 'pending',
    this.reference,
    this.description,
    this.notes,
    this.receiptNumber,
    required this.transactionDate,
    this.postedDate,
    this.isRecurring = false,
    this.recurringId,
    this.syncStatus = 'synced',
    this.syncVersion = 1,
    this.isDirty = false,
    this.lastSyncedAt,
    this.conflictData,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    universityId,
    transactionNumber,
    accountId,
    relatedAccountId,
    categoryId,
    paymentMethodId,
    amount,
    currency,
    type,
    status,
    reference,
    description,
    notes,
    receiptNumber,
    transactionDate,
    postedDate,
    isRecurring,
    recurringId,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdBy,
    createdAt,
    updatedAt,
  ];

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      transactionNumber: json['transaction_number'] as String,
      accountId: json['account_id'] as String,
      relatedAccountId: json['related_account_id'] as String?,
      categoryId: json['category_id'] as String,
      paymentMethodId: json['payment_method_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      type: json['type'] as String,
      status: json['status'] as String? ?? 'pending',
      reference: json['reference'] as String?,
      description: json['description'] as String?,
      notes: json['notes'] as String?,
      receiptNumber: json['receipt_number'] as String?,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      postedDate: json['posted_date'] != null
          ? DateTime.parse(json['posted_date'] as String)
          : null,
      isRecurring:
          (json['is_recurring'] as int?) == 1 ||
          (json['is_recurring'] as bool?) == true,
      recurringId: json['recurring_id'] as String?,
      syncStatus: json['sync_status'] as String? ?? 'synced',
      syncVersion: (json['sync_version'] as int?) ?? 1,
      isDirty:
          (json['is_dirty'] as int?) == 1 ||
          (json['is_dirty'] as bool?) == true,
      lastSyncedAt: json['last_synced_at'] != null
          ? DateTime.parse(json['last_synced_at'] as String)
          : null,
      conflictData: json['conflict_data'] != null
          ? Map<String, dynamic>.from(json['conflict_data'] as Map)
          : null,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'transaction_number': transactionNumber,
      'account_id': accountId,
      'related_account_id': relatedAccountId,
      'category_id': categoryId,
      'payment_method_id': paymentMethodId,
      'amount': amount,
      'currency': currency,
      'type': type,
      'status': status,
      'reference': reference,
      'description': description,
      'notes': notes,
      'receipt_number': receiptNumber,
      'transaction_date': transactionDate.toIso8601String(),
      'posted_date': postedDate?.toIso8601String(),
      'is_recurring': isRecurring ? 1 : 0,
      'recurring_id': recurringId,
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Transaction copyWith({
    String? id,
    String? universityId,
    String? transactionNumber,
    String? accountId,
    String? relatedAccountId,
    String? categoryId,
    String? paymentMethodId,
    double? amount,
    String? currency,
    String? type,
    String? status,
    String? reference,
    String? description,
    String? notes,
    String? receiptNumber,
    DateTime? transactionDate,
    DateTime? postedDate,
    bool? isRecurring,
    String? recurringId,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      transactionNumber: transactionNumber ?? this.transactionNumber,
      accountId: accountId ?? this.accountId,
      relatedAccountId: relatedAccountId ?? this.relatedAccountId,
      categoryId: categoryId ?? this.categoryId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      type: type ?? this.type,
      status: status ?? this.status,
      reference: reference ?? this.reference,
      description: description ?? this.description,
      notes: notes ?? this.notes,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      transactionDate: transactionDate ?? this.transactionDate,
      postedDate: postedDate ?? this.postedDate,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringId: recurringId ?? this.recurringId,
      syncStatus: syncStatus ?? this.syncStatus,
      syncVersion: syncVersion ?? this.syncVersion,
      isDirty: isDirty ?? this.isDirty,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      conflictData: conflictData ?? this.conflictData,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
