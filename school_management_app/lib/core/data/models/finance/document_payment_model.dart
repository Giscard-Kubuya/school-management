import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class DocumentPayment extends BaseModel {
  final String id;
  final String universityId;
  final String documentId;
  final String transactionId;
  final String studentId;
  final double amount;
  final String status; // pending, completed, failed, refunded
  final String? receiptNumber;
  final DateTime? paidAt;
  final String? notes;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DocumentPayment({
    required this.id,
    required this.universityId,
    required this.documentId,
    required this.transactionId,
    required this.studentId,
    required this.amount,
    this.status = 'pending',
    this.receiptNumber,
    this.paidAt,
    this.notes,
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
    documentId,
    transactionId,
    studentId,
    amount,
    status,
    receiptNumber,
    paidAt,
    notes,
    syncStatus,
    syncVersion,
    isDirty,
    lastSyncedAt,
    conflictData,
    createdAt,
    updatedAt,
  ];

  factory DocumentPayment.fromJson(Map<String, dynamic> json) {
    return DocumentPayment(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      documentId: json['document_id'] as String,
      transactionId: json['transaction_id'] as String,
      studentId: json['student_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String? ?? 'pending',
      receiptNumber: json['receipt_number'] as String?,
      paidAt: json['paid_at'] != null
          ? DateTime.parse(json['paid_at'] as String)
          : null,
      notes: json['notes'] as String?,
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
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'university_id': universityId,
      'document_id': documentId,
      'transaction_id': transactionId,
      'student_id': studentId,
      'amount': amount,
      'status': status,
      'receipt_number': receiptNumber,
      'paid_at': paidAt?.toIso8601String(),
      'notes': notes,
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  DocumentPayment copyWith({
    String? id,
    String? universityId,
    String? documentId,
    String? transactionId,
    String? studentId,
    double? amount,
    String? status,
    String? receiptNumber,
    DateTime? paidAt,
    String? notes,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DocumentPayment(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      documentId: documentId ?? this.documentId,
      transactionId: transactionId ?? this.transactionId,
      studentId: studentId ?? this.studentId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      paidAt: paidAt ?? this.paidAt,
      notes: notes ?? this.notes,
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
