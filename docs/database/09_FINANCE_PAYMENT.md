# Finance & Payment System Tables - Complete Schema

## Tables in this file:

1. financial_accounts
2. transactions
3. transaction_categories
4. payment_methods
5. document_payments
6. tuition_fees
7. fee_payments
8. payment_plans
9. financial_history
10. withdrawal_requests

---

## 1. financial_accounts

### MySQL (Laravel)

```sql
CREATE TABLE financial_accounts (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  account_holder_type ENUM('student', 'teacher', 'administrator', 'university') NOT NULL,
  account_holder_id VARCHAR(36) NOT NULL, -- ID of student/teacher/admin

  account_number VARCHAR(50) NOT NULL UNIQUE,
  account_type ENUM('wallet', 'salary', 'tuition', 'university_account') DEFAULT 'wallet',

  -- Balance
  current_balance DECIMAL(15,2) DEFAULT 0.00,
  available_balance DECIMAL(15,2) DEFAULT 0.00, -- Balance minus pending transactions
  pending_balance DECIMAL(15,2) DEFAULT 0.00,

  -- Limits
  daily_withdrawal_limit DECIMAL(15,2) DEFAULT 1000.00,
  daily_transfer_limit DECIMAL(15,2) DEFAULT 5000.00,
  minimum_balance DECIMAL(10,2) DEFAULT 0.00,

  -- Status
  account_status ENUM('active', 'suspended', 'frozen', 'closed') DEFAULT 'active',
  is_verified BOOLEAN DEFAULT FALSE,
  verified_at TIMESTAMP NULL,

  -- Currency
  currency VARCHAR(3) DEFAULT 'USD',

  -- Security
  pin_hash VARCHAR(255), -- For transaction PIN
  last_transaction_at TIMESTAMP NULL,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  INDEX idx_financial_accounts_university (university_id),
  INDEX idx_financial_accounts_holder (account_holder_type, account_holder_id),
  INDEX idx_financial_accounts_number (account_number),
  INDEX idx_financial_accounts_status (account_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)

```sql
CREATE TABLE financial_accounts (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  account_holder_type TEXT NOT NULL,
  account_holder_id TEXT NOT NULL,
  account_number TEXT NOT NULL UNIQUE,
  account_type TEXT DEFAULT 'wallet',
  current_balance REAL DEFAULT 0.00,
  available_balance REAL DEFAULT 0.00,
  pending_balance REAL DEFAULT 0.00,
  daily_withdrawal_limit REAL DEFAULT 1000.00,
  daily_transfer_limit REAL DEFAULT 5000.00,
  minimum_balance REAL DEFAULT 0.00,
  account_status TEXT DEFAULT 'active',
  is_verified INTEGER DEFAULT 0,
  verified_at TEXT,
  currency TEXT DEFAULT 'USD',
  pin_hash TEXT,
  last_transaction_at TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE
);

CREATE INDEX idx_financial_accounts_university ON financial_accounts(university_id);
CREATE INDEX idx_financial_accounts_holder ON financial_accounts(account_holder_type, account_holder_id);
CREATE INDEX idx_financial_accounts_number ON financial_accounts(account_number);
CREATE INDEX idx_financial_accounts_status ON financial_accounts(account_status);
```

---

## 2. transactions

### MySQL (Laravel)

```sql
CREATE TABLE transactions (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  transaction_number VARCHAR(50) NOT NULL UNIQUE,
  transaction_type ENUM('deposit', 'withdrawal', 'transfer', 'payment', 'refund', 'fee', 'salary') NOT NULL,

  -- Accounts involved
  from_account_id VARCHAR(36), -- NULL for deposits
  to_account_id VARCHAR(36), -- NULL for withdrawals

  -- Amount
  amount DECIMAL(15,2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'USD',

  -- Fees
  transaction_fee DECIMAL(10,2) DEFAULT 0.00,
  total_amount DECIMAL(15,2) NOT NULL, -- amount + fees

  -- Status
  status ENUM('pending', 'processing', 'completed', 'failed', 'cancelled', 'reversed') DEFAULT 'pending',

  -- Details
  category_id VARCHAR(36), -- Link to transaction_categories
  payment_method_id VARCHAR(36), -- Link to payment_methods

  description TEXT,
  reference_number VARCHAR(100),

  -- Related entities
  related_entity_type VARCHAR(50), -- 'document', 'tuition_fee', 'assignment', etc.
  related_entity_id VARCHAR(36),

  -- Processing
  initiated_by VARCHAR(36) NOT NULL, -- user_id
  approved_by VARCHAR(36), -- admin user_id for large transactions

  processed_at TIMESTAMP NULL,
  completed_at TIMESTAMP NULL,
  failed_at TIMESTAMP NULL,
  failure_reason TEXT,

  -- Receipt
  receipt_url VARCHAR(500),

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (from_account_id) REFERENCES financial_accounts(id) ON DELETE SET NULL,
  FOREIGN KEY (to_account_id) REFERENCES financial_accounts(id) ON DELETE SET NULL,
  FOREIGN KEY (category_id) REFERENCES transaction_categories(id) ON DELETE SET NULL,
  FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id) ON DELETE SET NULL,
  FOREIGN KEY (initiated_by) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_transactions_university (university_id),
  INDEX idx_transactions_from_account (from_account_id),
  INDEX idx_transactions_to_account (to_account_id),
  INDEX idx_transactions_number (transaction_number),
  INDEX idx_transactions_status (status),
  INDEX idx_transactions_type (transaction_type),
  INDEX idx_transactions_date (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)

```sql
CREATE TABLE transactions (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  transaction_number TEXT NOT NULL UNIQUE,
  transaction_type TEXT NOT NULL,
  from_account_id TEXT,
  to_account_id TEXT,
  amount REAL NOT NULL,
  currency TEXT DEFAULT 'USD',
  transaction_fee REAL DEFAULT 0.00,
  total_amount REAL NOT NULL,
  status TEXT DEFAULT 'pending',
  category_id TEXT,
  payment_method_id TEXT,
  description TEXT,
  reference_number TEXT,
  related_entity_type TEXT,
  related_entity_id TEXT,
  initiated_by TEXT NOT NULL,
  approved_by TEXT,
  processed_at TEXT,
  completed_at TEXT,
  failed_at TEXT,
  failure_reason TEXT,
  receipt_url TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (from_account_id) REFERENCES financial_accounts(id) ON DELETE SET NULL,
  FOREIGN KEY (to_account_id) REFERENCES financial_accounts(id) ON DELETE SET NULL,
  FOREIGN KEY (category_id) REFERENCES transaction_categories(id) ON DELETE SET NULL,
  FOREIGN KEY (payment_method_id) REFERENCES payment_methods(id) ON DELETE SET NULL,
  FOREIGN KEY (initiated_by) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_transactions_university ON transactions(university_id);
CREATE INDEX idx_transactions_from_account ON transactions(from_account_id);
CREATE INDEX idx_transactions_to_account ON transactions(to_account_id);
CREATE INDEX idx_transactions_number ON transactions(transaction_number);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_transactions_type ON transactions(transaction_type);
CREATE INDEX idx_transactions_date ON transactions(created_at);
```

---

## 3. transaction_categories

### MySQL (Laravel)

```sql
CREATE TABLE transaction_categories (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  category_name VARCHAR(100) NOT NULL,
  category_code VARCHAR(20) NOT NULL,
  category_type ENUM('income', 'expense') NOT NULL,

  description TEXT,
  icon VARCHAR(50), -- Icon name for UI
  color VARCHAR(20), -- Hex color for UI

  parent_category_id VARCHAR(36), -- For nested categories

  is_active BOOLEAN DEFAULT TRUE,
  is_system BOOLEAN DEFAULT FALSE, -- System categories cannot be deleted

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (parent_category_id) REFERENCES transaction_categories(id) ON DELETE SET NULL,
  UNIQUE KEY unique_category_code (university_id, category_code),
  INDEX idx_transaction_categories_university (university_id),
  INDEX idx_transaction_categories_type (category_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)

```sql
CREATE TABLE transaction_categories (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  category_name TEXT NOT NULL,
  category_code TEXT NOT NULL,
  category_type TEXT NOT NULL,
  description TEXT,
  icon TEXT,
  color TEXT,
  parent_category_id TEXT,
  is_active INTEGER DEFAULT 1,
  is_system INTEGER DEFAULT 0,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (parent_category_id) REFERENCES transaction_categories(id) ON DELETE SET NULL,
  UNIQUE(university_id, category_code)
);

CREATE INDEX idx_transaction_categories_university ON transaction_categories(university_id);
CREATE INDEX idx_transaction_categories_type ON transaction_categories(category_type);
```

---

## 4. payment_methods

### MySQL (Laravel)

```sql
CREATE TABLE payment_methods (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,
  user_id VARCHAR(36) NOT NULL,

  method_type ENUM('wallet', 'bank_account', 'mobile_money', 'credit_card', 'cash') NOT NULL,
  method_name VARCHAR(100) NOT NULL, -- User-friendly name

  -- Payment details (encrypted)
  provider_name VARCHAR(100), -- Bank name, Mobile Money provider, etc.
  account_number VARCHAR(100),
  account_name VARCHAR(255),

  -- Card details (if applicable, encrypted)
  card_last_four VARCHAR(4),
  card_type VARCHAR(20), -- Visa, Mastercard
  expiry_month INT,
  expiry_year INT,

  is_default BOOLEAN DEFAULT FALSE,
  is_active BOOLEAN DEFAULT TRUE,
  is_verified BOOLEAN DEFAULT FALSE,
  verified_at TIMESTAMP NULL,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_payment_methods_university (university_id),
  INDEX idx_payment_methods_user (user_id),
  INDEX idx_payment_methods_type (method_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)

```sql
CREATE TABLE payment_methods (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  method_type TEXT NOT NULL,
  method_name TEXT NOT NULL,
  provider_name TEXT,
  account_number TEXT,
  account_name TEXT,
  card_last_four TEXT,
  card_type TEXT,
  expiry_month INTEGER,
  expiry_year INTEGER,
  is_default INTEGER DEFAULT 0,
  is_active INTEGER DEFAULT 1,
  is_verified INTEGER DEFAULT 0,
  verified_at TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_payment_methods_university ON payment_methods(university_id);
CREATE INDEX idx_payment_methods_user ON payment_methods(user_id);
CREATE INDEX idx_payment_methods_type ON payment_methods(method_type);
```

---

## 5. document_payments

### MySQL (Laravel)

```sql
CREATE TABLE document_payments (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  document_id VARCHAR(36) NOT NULL,
  student_id VARCHAR(36) NOT NULL,

  -- Pricing
  price DECIMAL(10,2) NOT NULL,
  discount_percentage DECIMAL(5,2) DEFAULT 0.00,
  discount_amount DECIMAL(10,2) DEFAULT 0.00,
  final_price DECIMAL(10,2) NOT NULL,

  -- Payment
  transaction_id VARCHAR(36),
  payment_status ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',

  paid_at TIMESTAMP NULL,

  -- Access control
  access_granted BOOLEAN DEFAULT FALSE,
  access_expires_at TIMESTAMP NULL, -- NULL = lifetime access
  download_count INT DEFAULT 0,
  max_downloads INT, -- NULL = unlimited

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE SET NULL,
  UNIQUE KEY unique_document_student (document_id, student_id),
  INDEX idx_document_payments_university (university_id),
  INDEX idx_document_payments_document (document_id),
  INDEX idx_document_payments_student (student_id),
  INDEX idx_document_payments_status (payment_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)

```sql
CREATE TABLE document_payments (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  document_id TEXT NOT NULL,
  student_id TEXT NOT NULL,
  price REAL NOT NULL,
  discount_percentage REAL DEFAULT 0.00,
  discount_amount REAL DEFAULT 0.00,
  final_price REAL NOT NULL,
  transaction_id TEXT,
  payment_status TEXT DEFAULT 'pending',
  paid_at TEXT,
  access_granted INTEGER DEFAULT 0,
  access_expires_at TEXT,
  download_count INTEGER DEFAULT 0,
  max_downloads INTEGER,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE SET NULL,
  UNIQUE(document_id, student_id)
);

CREATE INDEX idx_document_payments_university ON document_payments(university_id);
CREATE INDEX idx_document_payments_document ON document_payments(document_id);
CREATE INDEX idx_document_payments_student ON document_payments(student_id);
CREATE INDEX idx_document_payments_status ON document_payments(payment_status);
```

---

## 6. tuition_fees

### MySQL (Laravel)

```sql
CREATE TABLE tuition_fees (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  student_id VARCHAR(36) NOT NULL,
  semester_id VARCHAR(36) NOT NULL,
  program_id VARCHAR(36) NOT NULL,

  -- Fee breakdown
  tuition_amount DECIMAL(15,2) NOT NULL,
  registration_fee DECIMAL(10,2) DEFAULT 0.00,
  library_fee DECIMAL(10,2) DEFAULT 0.00,
  lab_fee DECIMAL(10,2) DEFAULT 0.00,
  other_fees DECIMAL(10,2) DEFAULT 0.00,

  -- Discounts
  scholarship_discount DECIMAL(10,2) DEFAULT 0.00,
  other_discount DECIMAL(10,2) DEFAULT 0.00,

  -- Totals
  total_fees DECIMAL(15,2) NOT NULL,
  amount_paid DECIMAL(15,2) DEFAULT 0.00,
  balance_due DECIMAL(15,2) NOT NULL,

  -- Deadlines
  due_date DATE NOT NULL,
  late_payment_fee DECIMAL(10,2) DEFAULT 0.00,

  -- Status
  payment_status ENUM('unpaid', 'partial', 'paid', 'overdue', 'waived') DEFAULT 'unpaid',

  is_approved BOOLEAN DEFAULT TRUE,
  approved_by VARCHAR(36),
  approved_at TIMESTAMP NULL,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE,
  FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE,
  FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL,
  UNIQUE KEY unique_student_semester (student_id, semester_id),
  INDEX idx_tuition_fees_university (university_id),
  INDEX idx_tuition_fees_student (student_id),
  INDEX idx_tuition_fees_semester (semester_id),
  INDEX idx_tuition_fees_status (payment_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)

```sql
CREATE TABLE tuition_fees (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  student_id TEXT NOT NULL,
  semester_id TEXT NOT NULL,
  program_id TEXT NOT NULL,
  tuition_amount REAL NOT NULL,
  registration_fee REAL DEFAULT 0.00,
  library_fee REAL DEFAULT 0.00,
  lab_fee REAL DEFAULT 0.00,
  other_fees REAL DEFAULT 0.00,
  scholarship_discount REAL DEFAULT 0.00,
  other_discount REAL DEFAULT 0.00,
  total_fees REAL NOT NULL,
  amount_paid REAL DEFAULT 0.00,
  balance_due REAL NOT NULL,
  due_date TEXT NOT NULL,
  late_payment_fee REAL DEFAULT 0.00,
  payment_status TEXT DEFAULT 'unpaid',
  is_approved INTEGER DEFAULT 1,
  approved_by TEXT,
  approved_at TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (semester_id) REFERENCES semesters(id) ON DELETE CASCADE,
  FOREIGN KEY (program_id) REFERENCES programs(id) ON DELETE CASCADE,
  FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL,
  UNIQUE(student_id, semester_id)
);

CREATE INDEX idx_tuition_fees_university ON tuition_fees(university_id);
CREATE INDEX idx_tuition_fees_student ON tuition_fees(student_id);
CREATE INDEX idx_tuition_fees_semester ON tuition_fees(semester_id);
CREATE INDEX idx_tuition_fees_status ON tuition_fees(payment_status);
```

---

## 7. fee_payments

### MySQL (Laravel)

```sql
CREATE TABLE fee_payments (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  tuition_fee_id VARCHAR(36) NOT NULL,
  transaction_id VARCHAR(36) NOT NULL,

  amount_paid DECIMAL(15,2) NOT NULL,
  payment_date DATE NOT NULL,

  payment_type ENUM('full', 'partial', 'installment') DEFAULT 'partial',
  installment_number INT,

  notes TEXT,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (tuition_fee_id) REFERENCES tuition_fees(id) ON DELETE CASCADE,
  FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE CASCADE,
  INDEX idx_fee_payments_university (university_id),
  INDEX idx_fee_payments_tuition (tuition_fee_id),
  INDEX idx_fee_payments_transaction (transaction_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)

```sql
CREATE TABLE fee_payments (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  tuition_fee_id TEXT NOT NULL,
  transaction_id TEXT NOT NULL,
  amount_paid REAL NOT NULL,
  payment_date TEXT NOT NULL,
  payment_type TEXT DEFAULT 'partial',
  installment_number INTEGER,
  notes TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (tuition_fee_id) REFERENCES tuition_fees(id) ON DELETE CASCADE,
  FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE CASCADE
);

CREATE INDEX idx_fee_payments_university ON fee_payments(university_id);
CREATE INDEX idx_fee_payments_tuition ON fee_payments(tuition_fee_id);
CREATE INDEX idx_fee_payments_transaction ON fee_payments(transaction_id);
```

---

## 8. payment_plans

### MySQL (Laravel)

```sql
CREATE TABLE payment_plans (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  tuition_fee_id VARCHAR(36) NOT NULL,
  student_id VARCHAR(36) NOT NULL,

  plan_name VARCHAR(100) NOT NULL,
  total_amount DECIMAL(15,2) NOT NULL,
  number_of_installments INT NOT NULL,
  installment_amount DECIMAL(15,2) NOT NULL,

  start_date DATE NOT NULL,

  status ENUM('active', 'completed', 'cancelled', 'defaulted') DEFAULT 'active',

  created_by VARCHAR(36) NOT NULL,
  approved_by VARCHAR(36),
  approved_at TIMESTAMP NULL,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (tuition_fee_id) REFERENCES tuition_fees(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL,
  INDEX idx_payment_plans_university (university_id),
  INDEX idx_payment_plans_tuition (tuition_fee_id),
  INDEX idx_payment_plans_student (student_id),
  INDEX idx_payment_plans_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)

```sql
CREATE TABLE payment_plans (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  tuition_fee_id TEXT NOT NULL,
  student_id TEXT NOT NULL,
  plan_name TEXT NOT NULL,
  total_amount REAL NOT NULL,
  number_of_installments INTEGER NOT NULL,
  installment_amount REAL NOT NULL,
  start_date TEXT NOT NULL,
  status TEXT DEFAULT 'active',
  created_by TEXT NOT NULL,
  approved_by TEXT,
  approved_at TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (tuition_fee_id) REFERENCES tuition_fees(id) ON DELETE CASCADE,
  FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
  FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (approved_by) REFERENCES users(id) ON DELETE SET NULL
);

CREATE INDEX idx_payment_plans_university ON payment_plans(university_id);
CREATE INDEX idx_payment_plans_tuition ON payment_plans(tuition_fee_id);
CREATE INDEX idx_payment_plans_student ON payment_plans(student_id);
CREATE INDEX idx_payment_plans_status ON payment_plans(status);
```

---

## 9. financial_history

### MySQL (Laravel)

```sql
CREATE TABLE financial_history (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  account_id VARCHAR(36) NOT NULL,
  transaction_id VARCHAR(36),

  action_type ENUM('balance_update', 'limit_change', 'status_change', 'verification', 'other') NOT NULL,

  previous_value TEXT,
  new_value TEXT,

  description TEXT NOT NULL,

  performed_by VARCHAR(36) NOT NULL,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (account_id) REFERENCES financial_accounts(id) ON DELETE CASCADE,
  FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE SET NULL,
  FOREIGN KEY (performed_by) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_financial_history_university (university_id),
  INDEX idx_financial_history_account (account_id),
  INDEX idx_financial_history_transaction (transaction_id),
  INDEX idx_financial_history_date (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)

```sql
CREATE TABLE financial_history (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  account_id TEXT NOT NULL,
  transaction_id TEXT,
  action_type TEXT NOT NULL,
  previous_value TEXT,
  new_value TEXT,
  description TEXT NOT NULL,
  performed_by TEXT NOT NULL,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (account_id) REFERENCES financial_accounts(id) ON DELETE CASCADE,
  FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE SET NULL,
  FOREIGN KEY (performed_by) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX idx_financial_history_university ON financial_history(university_id);
CREATE INDEX idx_financial_history_account ON financial_history(account_id);
CREATE INDEX idx_financial_history_transaction ON financial_history(transaction_id);
CREATE INDEX idx_financial_history_date ON financial_history(created_at);
```

---

## 10. withdrawal_requests

### MySQL (Laravel)

```sql
CREATE TABLE withdrawal_requests (
  id VARCHAR(36) PRIMARY KEY,
  university_id VARCHAR(36) NOT NULL,

  account_id VARCHAR(36) NOT NULL,
  requested_by VARCHAR(36) NOT NULL,

  amount DECIMAL(15,2) NOT NULL,
  withdrawal_method ENUM('bank_transfer', 'mobile_money', 'cash', 'check') NOT NULL,

  -- Withdrawal details
  bank_account_number VARCHAR(100),
  bank_name VARCHAR(100),
  mobile_number VARCHAR(20),

  reason TEXT,

  -- Status
  status ENUM('pending', 'approved', 'processing', 'completed', 'rejected', 'cancelled') DEFAULT 'pending',

  -- Approval
  reviewed_by VARCHAR(36),
  reviewed_at TIMESTAMP NULL,
  review_notes TEXT,

  -- Processing
  transaction_id VARCHAR(36),
  processed_at TIMESTAMP NULL,
  completed_at TIMESTAMP NULL,

  -- Sync metadata
  sync_status VARCHAR(20) DEFAULT 'synced',
  sync_version INT DEFAULT 1,
  is_dirty BOOLEAN DEFAULT FALSE,
  last_synced_at TIMESTAMP NULL,
  conflict_data JSON NULL,

  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (account_id) REFERENCES financial_accounts(id) ON DELETE CASCADE,
  FOREIGN KEY (requested_by) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (reviewed_by) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE SET NULL,
  INDEX idx_withdrawal_requests_university (university_id),
  INDEX idx_withdrawal_requests_account (account_id),
  INDEX idx_withdrawal_requests_requester (requested_by),
  INDEX idx_withdrawal_requests_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### SQLite (Flutter)

```sql
CREATE TABLE withdrawal_requests (
  id TEXT PRIMARY KEY,
  university_id TEXT NOT NULL,
  account_id TEXT NOT NULL,
  requested_by TEXT NOT NULL,
  amount REAL NOT NULL,
  withdrawal_method TEXT NOT NULL,
  bank_account_number TEXT,
  bank_name TEXT,
  mobile_number TEXT,
  reason TEXT,
  status TEXT DEFAULT 'pending',
  reviewed_by TEXT,
  reviewed_at TEXT,
  review_notes TEXT,
  transaction_id TEXT,
  processed_at TEXT,
  completed_at TEXT,
  sync_status TEXT DEFAULT 'synced',
  sync_version INTEGER DEFAULT 1,
  is_dirty INTEGER DEFAULT 0,
  last_synced_at TEXT,
  conflict_data TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
  FOREIGN KEY (account_id) REFERENCES financial_accounts(id) ON DELETE CASCADE,
  FOREIGN KEY (requested_by) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (reviewed_by) REFERENCES users(id) ON DELETE SET NULL,
  FOREIGN KEY (transaction_id) REFERENCES transactions(id) ON DELETE SET NULL
);

CREATE INDEX idx_withdrawal_requests_university ON withdrawal_requests(university_id);
CREATE INDEX idx_withdrawal_requests_account ON withdrawal_requests(account_id);
CREATE INDEX idx_withdrawal_requests_requester ON withdrawal_requests(requested_by);
CREATE INDEX idx_withdrawal_requests_status ON withdrawal_requests(status);
```

---

**File 9 of 9 - Finance & Payment System Complete**

## 💰 Total Finance Tables: 10

1. financial_accounts - User wallet/account balances
2. transactions - All financial transactions
3. transaction_categories - Transaction categorization
4. payment_methods - User payment methods
5. document_payments - Paid document access
6. tuition_fees - Student tuition billing
7. fee_payments - Tuition payment records
8. payment_plans - Installment plans
9. financial_history - Audit trail
10. withdrawal_requests - Money withdrawal requests
