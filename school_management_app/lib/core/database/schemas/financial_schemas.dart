import 'package:school_management_app/core/database/database_tables.dart';

class FinancialSchemas {
  static const String financialAccounts =
      '''
    CREATE TABLE ${DatabaseTables.financialAccounts} (
      id TEXT PRIMARY KEY,
      user_id TEXT NOT NULL,
      account_type TEXT NOT NULL,
      account_number TEXT UNIQUE NOT NULL,
      balance DECIMAL(10,2) NOT NULL DEFAULT 0.00,
      currency TEXT NOT NULL,
      status TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE
    )
  ''';

  static const String transactionCategories =
      '''
    CREATE TABLE ${DatabaseTables.transactionCategories} (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT,
      type TEXT NOT NULL, -- 'income' or 'expense'
      is_system INTEGER DEFAULT 0,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
  ''';

  static const String transactions =
      '''
    CREATE TABLE ${DatabaseTables.transactions} (
      id TEXT PRIMARY KEY,
      account_id TEXT NOT NULL,
      category_id TEXT NOT NULL,
      amount DECIMAL(10,2) NOT NULL,
      transaction_date TEXT NOT NULL,
      description TEXT,
      reference_number TEXT,
      status TEXT NOT NULL,
      created_by TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (account_id) REFERENCES ${DatabaseTables.financialAccounts} (id) ON DELETE CASCADE,
      FOREIGN KEY (category_id) REFERENCES ${DatabaseTables.transactionCategories} (id) ON DELETE RESTRICT,
      FOREIGN KEY (created_by) REFERENCES ${DatabaseTables.users} (id)
    )
  ''';

  static const String paymentMethods =
      '''
    CREATE TABLE ${DatabaseTables.paymentMethods} (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT,
      is_active INTEGER DEFAULT 1,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
  ''';

  static const String tuitionFees =
      '''
    CREATE TABLE ${DatabaseTables.tuitionFees} (
      id TEXT PRIMARY KEY,
      program_id TEXT NOT NULL,
      academic_year_id TEXT NOT NULL,
      fee_type TEXT NOT NULL,
      amount DECIMAL(10,2) NOT NULL,
      is_per_semester INTEGER DEFAULT 1,
      due_date TEXT,
      is_active INTEGER DEFAULT 1,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (program_id) REFERENCES ${DatabaseTables.programs} (id) ON DELETE CASCADE,
      FOREIGN KEY (academic_year_id) REFERENCES ${DatabaseTables.academicYears} (id) ON DELETE CASCADE
    )
  ''';

  static const String paymentPlans =
      '''
    CREATE TABLE ${DatabaseTables.paymentPlans} (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT,
      total_amount DECIMAL(10,2) NOT NULL,
      number_of_installments INTEGER NOT NULL,
      is_active INTEGER DEFAULT 1,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL
    )
  ''';

  static const String paymentPlanInstallments =
      '''
    CREATE TABLE ${DatabaseTables.paymentPlanInstallments} (
      id TEXT PRIMARY KEY,
      payment_plan_id TEXT NOT NULL,
      installment_number INTEGER NOT NULL,
      amount DECIMAL(10,2) NOT NULL,
      due_date TEXT NOT NULL,
      is_paid INTEGER DEFAULT 0,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (payment_plan_id) REFERENCES ${DatabaseTables.paymentPlans} (id) ON DELETE CASCADE
    )
  ''';

  static const String feePayments =
      '''
    CREATE TABLE ${DatabaseTables.feePayments} (
      id TEXT PRIMARY KEY,
      student_id TEXT NOT NULL,
      tuition_fee_id TEXT,
      payment_plan_installment_id TEXT,
      amount_paid DECIMAL(10,2) NOT NULL,
      payment_date TEXT NOT NULL,
      payment_method_id TEXT NOT NULL,
      reference_number TEXT,
      status TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (student_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE,
      FOREIGN KEY (tuition_fee_id) REFERENCES ${DatabaseTables.tuitionFees} (id) ON DELETE SET NULL,
      FOREIGN KEY (payment_plan_installment_id) REFERENCES ${DatabaseTables.paymentPlanInstallments} (id) ON DELETE SET NULL,
      FOREIGN KEY (payment_method_id) REFERENCES ${DatabaseTables.paymentMethods} (id) ON DELETE RESTRICT
    )
  ''';

  static const String documentPayments =
      '''
    CREATE TABLE ${DatabaseTables.documentPayments} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      document_id TEXT NOT NULL,
      student_id TEXT NOT NULL,
      amount DECIMAL(10,2) NOT NULL,
      payment_date TEXT NOT NULL,
      payment_method_id TEXT NOT NULL,
      transaction_id TEXT,
      status TEXT NOT NULL,
      receipt_number TEXT,
      notes TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (document_id) REFERENCES ${DatabaseTables.documents} (id) ON DELETE CASCADE,
      FOREIGN KEY (student_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE,
      FOREIGN KEY (payment_method_id) REFERENCES ${DatabaseTables.paymentMethods} (id) ON DELETE RESTRICT,
      FOREIGN KEY (transaction_id) REFERENCES ${DatabaseTables.transactions} (id) ON DELETE SET NULL
    )
  ''';

  static const String financialHistory =
      '''
    CREATE TABLE ${DatabaseTables.financialHistory} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      account_id TEXT NOT NULL,
      transaction_id TEXT,
      transaction_type TEXT NOT NULL,
      amount DECIMAL(10,2) NOT NULL,
      balance_before DECIMAL(10,2) NOT NULL,
      balance_after DECIMAL(10,2) NOT NULL,
      description TEXT,
      reference_number TEXT,
      status TEXT NOT NULL,
      created_by TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (account_id) REFERENCES ${DatabaseTables.financialAccounts} (id) ON DELETE CASCADE,
      FOREIGN KEY (transaction_id) REFERENCES ${DatabaseTables.transactions} (id) ON DELETE SET NULL,
      FOREIGN KEY (created_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE
    )
  ''';

  static const String withdrawalRequests =
      '''
    CREATE TABLE ${DatabaseTables.withdrawalRequests} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      account_id TEXT NOT NULL,
      requested_by TEXT NOT NULL,
      amount DECIMAL(10,2) NOT NULL,
      payment_method_id TEXT NOT NULL,
      status TEXT NOT NULL,
      reason TEXT,
      approved_by TEXT,
      approved_at TEXT,
      transaction_id TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (account_id) REFERENCES ${DatabaseTables.financialAccounts} (id) ON DELETE CASCADE,
      FOREIGN KEY (requested_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE,
      FOREIGN KEY (payment_method_id) REFERENCES ${DatabaseTables.paymentMethods} (id) ON DELETE RESTRICT,
      FOREIGN KEY (approved_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE SET NULL,
      FOREIGN KEY (transaction_id) REFERENCES ${DatabaseTables.transactions} (id) ON DELETE SET NULL
    )
  ''';

  // Indexes for better query performance
  static const List<String> indexes = [
    'CREATE INDEX idx_financial_accounts_user_id ON ${DatabaseTables.financialAccounts}(user_id)',
    'CREATE INDEX idx_financial_accounts_status ON ${DatabaseTables.financialAccounts}(status)',
    'CREATE INDEX idx_transactions_account_id ON ${DatabaseTables.transactions}(account_id)',
    'CREATE INDEX idx_transactions_date ON ${DatabaseTables.transactions}(transaction_date)',
    'CREATE INDEX idx_transactions_category ON ${DatabaseTables.transactions}(category_id)',
    'CREATE INDEX idx_payment_plans_status ON ${DatabaseTables.paymentPlans}(is_active)',
    'CREATE INDEX idx_payment_plan_installments_plan_id ON ${DatabaseTables.paymentPlanInstallments}(payment_plan_id)',
    'CREATE INDEX idx_payment_plan_installments_due_date ON ${DatabaseTables.paymentPlanInstallments}(due_date)',
    'CREATE INDEX idx_fee_payments_student_id ON ${DatabaseTables.feePayments}(student_id)',
    'CREATE INDEX idx_fee_payments_status ON ${DatabaseTables.feePayments}(status)',
    'CREATE INDEX idx_document_payments_student_id ON ${DatabaseTables.documentPayments}(student_id)',
    'CREATE INDEX idx_document_payments_document_id ON ${DatabaseTables.documentPayments}(document_id)',
    'CREATE INDEX idx_financial_history_account_id ON ${DatabaseTables.financialHistory}(account_id)',
    'CREATE INDEX idx_financial_history_transaction_id ON ${DatabaseTables.financialHistory}(transaction_id)',
    'CREATE INDEX idx_withdrawal_requests_account_id ON ${DatabaseTables.withdrawalRequests}(account_id)',
    'CREATE INDEX idx_withdrawal_requests_status ON ${DatabaseTables.withdrawalRequests}(status)',
    'CREATE INDEX idx_withdrawal_requests_requested_by ON ${DatabaseTables.withdrawalRequests}(requested_by)',
  ];

  // All schema definitions
  static const List<String> all = [
    financialAccounts,
    transactionCategories,
    transactions,
    paymentMethods,
    tuitionFees,
    paymentPlans,
    paymentPlanInstallments,
    feePayments,
    documentPayments,
    financialHistory,
    withdrawalRequests,
  ];

  // Combine all SQL statements including indexes
  static List<String> get allWithIndexes => [...all, ...indexes];
}
