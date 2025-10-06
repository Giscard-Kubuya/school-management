/// Finance and Payment Schema
/// 
/// Contains table definitions for:
/// - financial_accounts
/// - financial_transactions
/// - tuition_plans
/// - student_payments
/// - payment_methods

class FinancePaymentSchema {
  static const List<String> createTableStatements = [
    _createFinancialAccountsTable,
    _createFinancialTransactionsTable,
    _createTuitionPlansTable,
    _createStudentPaymentsTable,
    _createPaymentMethodsTable,
  ];

  static const List<String> createIndexStatements = [
    'CREATE INDEX idx_financial_accounts_owner ON financial_accounts(owner_id)',
    'CREATE INDEX idx_financial_accounts_type ON financial_accounts(account_type)',
    'CREATE INDEX idx_transactions_account ON financial_transactions(account_id)',
    'CREATE INDEX idx_transactions_student ON financial_transactions(student_id)',
    'CREATE INDEX idx_tuition_plans_program ON tuition_plans(program_id)',
    'CREATE INDEX idx_student_payments_student ON student_payments(student_id)',
    'CREATE INDEX idx_student_payments_method ON student_payments(payment_method_id)',
  ];

  // ==================== TABLE DEFINITIONS ====================

  static const String _createFinancialAccountsTable = '''
    CREATE TABLE financial_accounts (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      owner_id TEXT,
      account_number TEXT NOT NULL,
      account_type TEXT NOT NULL, -- 'student', 'department', 'university', 'scholarship', 'loan'
      account_name TEXT NOT NULL,
      description TEXT,
      current_balance REAL NOT NULL DEFAULT 0,
      available_balance REAL NOT NULL DEFAULT 0,
      currency_code TEXT DEFAULT 'USD',
      is_active INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
      FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE SET NULL,
      UNIQUE(university_id, account_number)
    )
  ''';

  static const String _createFinancialTransactionsTable = '''
    CREATE TABLE financial_transactions (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      account_id TEXT NOT NULL,
      student_id TEXT,
      transaction_type TEXT NOT NULL, -- 'tuition', 'payment', 'refund', 'scholarship', 'fine', 'other'
      reference_id TEXT,
      reference_type TEXT,
      amount REAL NOT NULL,
      running_balance REAL NOT NULL,
      currency_code TEXT DEFAULT 'USD',
      description TEXT,
      transaction_date TEXT NOT NULL,
      posted_date TEXT NOT NULL,
      is_reconciled INTEGER DEFAULT 0,
      reconciled_by TEXT,
      reconciled_at TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
      FOREIGN KEY (account_id) REFERENCES financial_accounts(id) ON DELETE CASCADE,
      FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE SET NULL,
      FOREIGN KEY (reconciled_by) REFERENCES users(id) ON DELETE SET NULL
    )
  ''';

  static const String _createTuitionPlansTable = '''
    CREATE TABLE tuition_plans (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      program_id TEXT NOT NULL,
      name TEXT NOT NULL,
      description TEXT,
      academic_year_id TEXT NOT NULL,
      semester_id TEXT,
      tuition_amount REAL NOT NULL,
      fee_amount REAL DEFAULT 0,
      other_charges REAL DEFAULT 0,
      total_amount REAL NOT NULL,
      is_active INTEGER DEFAULT 1,
      due_date TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
      FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE,
      FOREIGN KEY (academic_year_id) REFERENCES academic_years(id) ON DELETE CASCADE,
      FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE SET NULL
    )
  ''';

  static const String _createStudentPaymentsTable = '''
    CREATE TABLE student_payments (
      id TEXT PRIMARY KEY,
      student_id TEXT NOT NULL,
      tuition_plan_id TEXT NOT NULL,
      payment_method_id TEXT,
      transaction_id TEXT,
      amount REAL NOT NULL,
      payment_date TEXT NOT NULL,
      payment_status TEXT NOT NULL, -- 'pending', 'completed', 'failed', 'refunded', 'partially_refunded'
      reference_number TEXT,
      notes TEXT,
      processed_by TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (tuition_plan_id) REFERENCES tuition_plans(id) ON DELETE CASCADE,
      FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id) ON DELETE SET NULL,
      FOREIGN KEY (transaction_id) REFERENCES financial_transactions(id) ON DELETE SET NULL,
      FOREIGN KEY (processed_by) REFERENCES users(id) ON DELETE SET NULL
    )
  ''';

  static const String _createPaymentMethodsTable = '''
    CREATE TABLE payment_methods (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      name TEXT NOT NULL,
      description TEXT,
      payment_type TEXT NOT NULL, -- 'credit_card', 'bank_transfer', 'mobile_money', 'cash', 'check'
      is_online INTEGER DEFAULT 0,
      processing_fee_type TEXT DEFAULT 'percentage', -- 'percentage' or 'fixed'
      processing_fee_value REAL DEFAULT 0,
      is_active INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
      UNIQUE(university_id, name)
    )
  ''';

  // Prevent instantiation
  FinancePaymentSchema._();
}
