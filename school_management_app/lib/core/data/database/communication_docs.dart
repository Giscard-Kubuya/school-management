/// Communication and Documents Schema
/// 
/// Contains table definitions for:
/// - announcements
/// - messages
/// - notifications
/// - documents
/// - document_shares

class CommunicationDocsSchema {
  static const List<String> createTableStatements = [
    _createAnnouncementsTable,
    _createMessagesTable,
    _createNotificationsTable,
    _createDocumentsTable,
    _createDocumentSharesTable,
  ];

  static const List<String> createIndexStatements = [
    'CREATE INDEX idx_announcements_sender ON announcements(sender_id)',
    'CREATE INDEX idx_announcements_course ON announcements(course_offering_id)',
    'CREATE INDEX idx_messages_sender ON messages(sender_id)',
    'CREATE INDEX idx_messages_recipient ON messages(recipient_id)',
    'CREATE INDEX idx_messages_thread ON messages(thread_id)',
    'CREATE INDEX idx_notifications_recipient ON notifications(recipient_id)',
    'CREATE INDEX idx_documents_owner ON documents(owner_id)',
    'CREATE INDEX idx_document_shares_document ON document_shares(document_id)',
    'CREATE INDEX idx_document_shares_recipient ON document_shares(shared_with_id)',
  ];

  // ==================== TABLE DEFINITIONS ====================

  static const String _createAnnouncementsTable = '''
    CREATE TABLE announcements (
      id TEXT PRIMARY KEY,
      sender_id TEXT NOT NULL,
      course_offering_id TEXT,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      is_pinned INTEGER DEFAULT 0,
      is_public INTEGER DEFAULT 0,
      allow_comments INTEGER DEFAULT 1,
      publish_date TEXT NOT NULL,
      expiry_date TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (course_offering_id) REFERENCES course_offerings(id) ON DELETE CASCADE
    )
  ''';

  static const String _createMessagesTable = '''
    CREATE TABLE messages (
      id TEXT PRIMARY KEY,
      thread_id TEXT NOT NULL,
      sender_id TEXT NOT NULL,
      recipient_id TEXT,
      recipient_group_id TEXT,
      subject TEXT,
      content TEXT NOT NULL,
      is_read INTEGER DEFAULT 0,
      is_starred INTEGER DEFAULT 0,
      is_important INTEGER DEFAULT 0,
      parent_message_id TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (recipient_id) REFERENCES users(id) ON DELETE SET NULL,
      FOREIGN KEY (parent_message_id) REFERENCES messages(id) ON DELETE SET NULL
    )
  ''';

  static const String _createNotificationsTable = '''
    CREATE TABLE notifications (
      id TEXT PRIMARY KEY,
      recipient_id TEXT NOT NULL,
      sender_id TEXT,
      title TEXT NOT NULL,
      message TEXT NOT NULL,
      notification_type TEXT NOT NULL,
      reference_id TEXT,
      reference_type TEXT,
      is_read INTEGER DEFAULT 0,
      action_url TEXT,
      scheduled_at TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (recipient_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE SET NULL
    )
  ''';

  static const String _createDocumentsTable = '''
    CREATE TABLE documents (
      id TEXT PRIMARY KEY,
      owner_id TEXT NOT NULL,
      parent_id TEXT,
      title TEXT NOT NULL,
      description TEXT,
      file_name TEXT NOT NULL,
      file_path TEXT NOT NULL,
      file_size INTEGER NOT NULL,
      file_type TEXT NOT NULL,
      mime_type TEXT NOT NULL,
      is_encrypted INTEGER DEFAULT 0,
      is_shared INTEGER DEFAULT 0,
      version_number INTEGER DEFAULT 1,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (parent_id) REFERENCES documents(id) ON DELETE CASCADE
    )
  ''';

  static const String _createDocumentSharesTable = '''
    CREATE TABLE document_shares (
      id TEXT PRIMARY KEY,
      document_id TEXT NOT NULL,
      shared_by_id TEXT NOT NULL,
      shared_with_id TEXT,
      shared_with_group_id TEXT,
      permission_level TEXT NOT NULL, -- 'view', 'comment', 'edit', 'manage'
      expires_at TEXT,
      is_revoked INTEGER DEFAULT 0,
      revoked_at TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE,
      FOREIGN KEY (shared_by_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY (shared_with_id) REFERENCES users(id) ON DELETE CASCADE,
      UNIQUE(document_id, shared_with_id, shared_with_group_id)
    )
  ''';

  // Prevent instantiation
  CommunicationDocsSchema._();
}
