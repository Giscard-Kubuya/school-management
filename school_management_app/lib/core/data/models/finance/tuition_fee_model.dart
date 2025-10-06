import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class TuitionFee extends BaseModel {
  final String id;
  final String universityId;
  final String studentId;
  final String academicYearId;
  final String? semesterId;
  final String programId;
  final String feeStructureId;
  final double totalAmount;
  final double paidAmount;
  final double balance;
  final String status; // unpaid, partially_paid, paid, overdue, waived, refunded
  final DateTime? dueDate;
  final String? paymentPlanId;
  final String? notes;
  final String? waivedBy;
  final DateTime? waivedAt;
  final String? waiverReason;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TuitionFee({
    required this.id,
    required this.universityId,
    required this.studentId,
    required this.academicYearId,
    this.semesterId,
    required this.programId,
    required this.feeStructureId,
    required this.totalAmount,
    this.paidAmount = 0.0,
    this.balance = 0.0,
    this.status = 'unpaid',
    this.dueDate,
    this.paymentPlanId,
    this.notes,
    this.waivedBy,
    this.waivedAt,
    this.waiverReason,
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
        studentId,
        academicYearId,
        semesterId,
        programId,
        feeStructureId,
        totalAmount,
        paidAmount,
        balance,
        status,
        dueDate,
        paymentPlanId,
        notes,
        waivedBy,
        waivedAt,
        waiverReason,
        syncStatus,
        syncVersion,
        isDirty,
        lastSyncedAt,
        conflictData,
        createdBy,
        createdAt,
        updatedAt,
      ];

  factory TuitionFee.fromJson(Map<String, dynamic> json) {
    return TuitionFee(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      studentId: json['student_id'] as String,
      academicYearId: json['academic_year_id'] as String,
      semesterId: json['semester_id'] as String?,
      programId: json['program_id'] as String,
      feeStructureId: json['fee_structure_id'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      paidAmount: (json['paid_amount'] as num?)?.toDouble() ?? 0.0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'unpaid',
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      paymentPlanId: json['payment_plan_id'] as String?,
      notes: json['notes'] as String?,
      waivedBy: json['waived_by'] as String?,
      waivedAt: json['waived_at'] != null
          ? DateTime.parse(json['waived_at'] as String)
          : null,
      waiverReason: json['waiver_reason'] as String?,
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
      'student_id': studentId,
      'academic_year_id': academicYearId,
      'semester_id': semesterId,
      'program_id': programId,
      'fee_structure_id': feeStructureId,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'balance': balance,
      'status': status,
      'due_date': dueDate?.toIso8601String().split('T')[0],
      'payment_plan_id': paymentPlanId,
      'notes': notes,
      'waived_by': waivedBy,
      'waived_at': waivedAt?.toIso8601String(),
      'waiver_reason': waiverReason,
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

  TuitionFee copyWith({
    String? id,
    String? universityId,
    String? studentId,
    String? academicYearId,
    String? semesterId,
    String? programId,
    String? feeStructureId,
    double? totalAmount,
    double? paidAmount,
    double? balance,
    String? status,
    DateTime? dueDate,
    String? paymentPlanId,
    String? notes,
    String? waivedBy,
    DateTime? waivedAt,
    String? waiverReason,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TuitionFee(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      studentId: studentId ?? this.studentId,
      academicYearId: academicYearId ?? this.academicYearId,
      semesterId: semesterId ?? this.semesterId,
      programId: programId ?? this.programId,
      feeStructureId: feeStructureId ?? this.feeStructureId,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      balance: balance ?? this.balance,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      paymentPlanId: paymentPlanId ?? this.paymentPlanId,
      notes: notes ?? this.notes,
      waivedBy: waivedBy ?? this.waivedBy,
      waivedAt: waivedAt ?? this.waivedAt,
      waiverReason: waiverReason ?? this.waiverReason,
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
