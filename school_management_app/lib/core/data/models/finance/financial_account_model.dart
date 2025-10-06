import 'package:flutter/foundation.dart';
import '../../base_model.dart';

@immutable
class FinancialAccount extends BaseModel {
  final String id;
  final String universityId;
  final String accountHolderType; // student, teacher, administrator, university
  final String accountHolderId;
  final String accountNumber;
  final String accountType; // wallet, salary, tuition, university_account
  final double currentBalance;
  final double availableBalance;
  final double pendingBalance;
  final double dailyWithdrawalLimit;
  final double dailyTransferLimit;
  final double minimumBalance;
  final String accountStatus; // active, suspended, frozen, closed
  final bool isVerified;
  final DateTime? verifiedAt;
  final String currency;
  final String syncStatus;
  final int syncVersion;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? conflictData;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FinancialAccount({
    required this.id,
    required this.universityId,
    required this.accountHolderType,
    required this.accountHolderId,
    required this.accountNumber,
    this.accountType = 'wallet',
    this.currentBalance = 0.0,
    this.availableBalance = 0.0,
    this.pendingBalance = 0.0,
    this.dailyWithdrawalLimit = 1000.0,
    this.dailyTransferLimit = 5000.0,
    this.minimumBalance = 0.0,
    this.accountStatus = 'active',
    this.isVerified = false,
    this.verifiedAt,
    this.currency = 'USD',
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
        accountHolderType,
        accountHolderId,
        accountNumber,
        accountType,
        currentBalance,
        availableBalance,
        pendingBalance,
        dailyWithdrawalLimit,
        dailyTransferLimit,
        minimumBalance,
        accountStatus,
        isVerified,
        verifiedAt,
        currency,
        syncStatus,
        syncVersion,
        isDirty,
        lastSyncedAt,
        conflictData,
        createdAt,
        updatedAt,
      ];

  factory FinancialAccount.fromJson(Map<String, dynamic> json) {
    return FinancialAccount(
      id: json['id'] as String,
      universityId: json['university_id'] as String,
      accountHolderType: json['account_holder_type'] as String,
      accountHolderId: json['account_holder_id'] as String,
      accountNumber: json['account_number'] as String,
      accountType: json['account_type'] as String? ?? 'wallet',
      currentBalance: (json['current_balance'] as num).toDouble(),
      availableBalance: (json['available_balance'] as num?)?.toDouble() ?? 0.0,
      pendingBalance: (json['pending_balance'] as num?)?.toDouble() ?? 0.0,
      dailyWithdrawalLimit: (json['daily_withdrawal_limit'] as num?)?.toDouble() ?? 1000.0,
      dailyTransferLimit: (json['daily_transfer_limit'] as num?)?.toDouble() ?? 5000.0,
      minimumBalance: (json['minimum_balance'] as num?)?.toDouble() ?? 0.0,
      accountStatus: json['account_status'] as String? ?? 'active',
      isVerified: (json['is_verified'] as int?) == 1 || (json['is_verified'] as bool?) == true,
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'] as String)
          : null,
      currency: json['currency'] as String? ?? 'USD',
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
      'account_holder_type': accountHolderType,
      'account_holder_id': accountHolderId,
      'account_number': accountNumber,
      'account_type': accountType,
      'current_balance': currentBalance,
      'available_balance': availableBalance,
      'pending_balance': pendingBalance,
      'daily_withdrawal_limit': dailyWithdrawalLimit,
      'daily_transfer_limit': dailyTransferLimit,
      'minimum_balance': minimumBalance,
      'account_status': accountStatus,
      'is_verified': isVerified ? 1 : 0,
      'verified_at': verifiedAt?.toIso8601String(),
      'currency': currency,
      'sync_status': syncStatus,
      'sync_version': syncVersion,
      'is_dirty': isDirty ? 1 : 0,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'conflict_data': conflictData,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  FinancialAccount copyWith({
    String? id,
    String? universityId,
    String? accountHolderType,
    String? accountHolderId,
    String? accountNumber,
    String? accountType,
    double? currentBalance,
    double? availableBalance,
    double? pendingBalance,
    double? dailyWithdrawalLimit,
    double? dailyTransferLimit,
    double? minimumBalance,
    String? accountStatus,
    bool? isVerified,
    DateTime? verifiedAt,
    String? currency,
    String? syncStatus,
    int? syncVersion,
    bool? isDirty,
    DateTime? lastSyncedAt,
    Map<String, dynamic>? conflictData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FinancialAccount(
      id: id ?? this.id,
      universityId: universityId ?? this.universityId,
      accountHolderType: accountHolderType ?? this.accountHolderType,
      accountHolderId: accountHolderId ?? this.accountHolderId,
      accountNumber: accountNumber ?? this.accountNumber,
      accountType: accountType ?? this.accountType,
      currentBalance: currentBalance ?? this.currentBalance,
      availableBalance: availableBalance ?? this.availableBalance,
      pendingBalance: pendingBalance ?? this.pendingBalance,
      dailyWithdrawalLimit: dailyWithdrawalLimit ?? this.dailyWithdrawalLimit,
      dailyTransferLimit: dailyTransferLimit ?? this.dailyTransferLimit,
      minimumBalance: minimumBalance ?? this.minimumBalance,
      accountStatus: accountStatus ?? this.accountStatus,
      isVerified: isVerified ?? this.isVerified,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      currency: currency ?? this.currency,
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
