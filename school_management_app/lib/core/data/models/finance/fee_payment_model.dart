import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class FeePayment extends BaseModel {
  final String id;
  final String universityId;
  final String tuitionFeeId;
  final String transactionId;
  final String studentId;
  final String paymentMethodId;
  final double amount;
  final double? discountAmount;
  final double? fineAmount;
  final String? receiptNumber;
  final String status; // pending, completed, failed, refunded
  final DateTime paymentDate;
  final String? notes;
  final String? receivedBy;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FeePayment({
    required this.id,
    required this.universityId,
    required this.tuitionFeeId,
    required this.transactionId,
    required this.studentId,
    required this.paymentMethodId,
    required this.amount,
    this.discountAmount,
    this.fineAmount,
    this.receiptNumber,
    this.status = 'completed',
    required this.paymentDate,
    this.notes,
    this.receivedBy,
    this.approvedBy,
    this.approvedAt,
    this.syncStatus = 'synced',
    this.syncVersion = 1,
    this.isDirty = false,
    this.lastSyncedAt,
    this.conflictData,
    required this.createdBy,
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
        tuitionFeeId,
        transactionId,
        studentId,
        paymentMethodId,
        amount,
        discountAmount,
        fineAmount,
        receiptNumber,
        status,
        paymentDate,
        notes,
        receivedBy,
        approvedBy,
        approvedAt,
        syncStatus,
        syncVersion,
        isDirty,
        lastSyncedAt,
        conflictData,
        createdBy,
        createdAt,
        updatedAt,
      ];

  factory FeePayment.fromJson(Map<String, dynamic> json) {
    return FeePayment(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      tuitionFeeId: json['tuition_fee_id'] as String,
      transactionId: json['transaction_id'] as String,
      studentId: json['student_id'] as String,
      paymentMethodId: json['payment_method_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
      fineAmount: (json['fine_amount'] as num?)?.toDouble(),
      receiptNumber: json['receipt_number'] as String?,
      status: json['status'] as String? ?? 'completed',
      paymentDate: DateTime.parse(json['payment_date'] as String),
      notes: json['notes'] as String?,
      receivedBy: json['received_by'] as String?,
      approvedBy: json['approved_by'] as String?,
      approvedAt: json['approved_at'] != null
          ? DateTime.parse(json['approved_at'] as String)
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
      'tuition_fee_id': tuitionFeeId,
      'transaction_id': transactionId,
      'student_id': studentId,
      'payment_method_id': paymentMethodId,
      'amount': amount,
      'discount_amount': discountAmount,
      'fine_amount': fineAmount,
      'receipt_number': receiptNumber,
      'status': status,
      'payment_date': paymentDate.toIso8601String().split('T')[0],
      'notes': notes,
      'received_by': receivedBy,
      'approved_by': approvedBy,
      'approved_at': approvedAt?.toIso8601String(),
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

  FeePayment copyWith({
    String? id,
    String? universityId,
    String? tuitionFeeId,
    String? transactionId,
    String? studentId,
    String? paymentMethodId,
    double? amount,
    double? discountAmount,
    double? fineAmount,
    String? receiptNumber,
    String? status,
    DateTime? paymentDate,
    String? notes,
    String? receivedBy,
    String? approvedBy,
    DateTime? approvedAt,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FeePayment(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      tuitionFeeId: tuitionFeeId ?? this.tuitionFeeId,
      transactionId: transactionId ?? this.transactionId,
      studentId: studentId ?? this.studentId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      amount: amount ?? this.amount,
      discountAmount: discountAmount ?? this.discountAmount,
      fineAmount: fineAmount ?? this.fineAmount,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      status: status ?? this.status,
      paymentDate: paymentDate ?? this.paymentDate,
      notes: notes ?? this.notes,
      receivedBy: receivedBy ?? this.receivedBy,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
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
