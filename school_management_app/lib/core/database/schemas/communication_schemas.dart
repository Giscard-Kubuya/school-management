import 'package:school_management_app/core/database/database_tables.dart';

class CommunicationSchemas {
  // Messages table
  static const String messages =
      '''
    CREATE TABLE ${DatabaseTables.messages} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      sender_id TEXT NOT NULL,
      receiver_id TEXT NOT NULL,
      subject TEXT,
      message_body TEXT NOT NULL,
      message_type TEXT CHECK(message_type IN ('direct', 'course', 'announcement')) DEFAULT 'direct',
      course_offering_id TEXT,
      parent_message_id TEXT,
      is_read INTEGER DEFAULT 0,
      read_at TEXT,
      priority TEXT CHECK(priority IN ('low', 'normal', 'high', 'urgent')) DEFAULT 'normal',
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (sender_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE,
      FOREIGN KEY (receiver_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE,
      FOREIGN KEY (course_offering_id) REFERENCES ${DatabaseTables.courseOfferings} (id) ON DELETE SET NULL,
      FOREIGN KEY (parent_message_id) REFERENCES ${DatabaseTables.messages} (id) ON DELETE SET NULL
    )
  ''';

  // Message Attachments table
  static const String messageAttachments =
      '''
    CREATE TABLE ${DatabaseTables.messageAttachments} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      message_id TEXT NOT NULL,
      file_name TEXT NOT NULL,
      file_url TEXT NOT NULL,
      file_size INTEGER NOT NULL,
      file_type TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (message_id) REFERENCES ${DatabaseTables.messages} (id) ON DELETE CASCADE
    )
  ''';

  // Announcements table
  static const String announcements =
      '''
    CREATE TABLE ${DatabaseTables.announcements} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      title TEXT NOT NULL,
      content TEXT NOT NULL,
      announcement_type TEXT CHECK(announcement_type IN ('general', 'academic', 'event', 'emergency')) DEFAULT 'general',
      start_date TEXT NOT NULL,
      end_date TEXT,
      is_published INTEGER DEFAULT 0,
      requires_acknowledgment INTEGER DEFAULT 0,
      created_by TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (created_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE
    )
  ''';

  // Announcement Recipients table
  static const String announcementRecipients =
      '''
    CREATE TABLE ${DatabaseTables.announcementRecipients} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      announcement_id TEXT NOT NULL,
      recipient_type TEXT CHECK(recipient_type IN ('all', 'role', 'user', 'course', 'program', 'department')) NOT NULL,
      recipient_id TEXT,
      acknowledged INTEGER DEFAULT 0,
      acknowledged_at TEXT,
      created_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (announcement_id) REFERENCES ${DatabaseTables.announcements} (id) ON DELETE CASCADE
    )
  ''';

  // Notifications table
  static const String notifications =
      '''
    CREATE TABLE ${DatabaseTables.notifications} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      user_id TEXT NOT NULL,
      title TEXT NOT NULL,
      message TEXT NOT NULL,
      notification_type TEXT CHECK(notification_type IN ('system', 'message', 'announcement', 'assignment', 'grade', 'attendance', 'payment')) NOT NULL,
      is_read INTEGER DEFAULT 0,
      read_at TEXT,
      action_url TEXT,
      related_entity_type TEXT,
      related_entity_id TEXT,
      priority INTEGER DEFAULT 0,
      expires_at TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE
    )
  ''';

  // Message Recipients table
  static const String messageRecipients =
      '''
    CREATE TABLE ${DatabaseTables.messageRecipients} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      message_id TEXT NOT NULL,
      recipient_id TEXT NOT NULL,
      recipient_type TEXT CHECK(recipient_type IN ('user', 'group', 'class', 'course')) NOT NULL,
      is_read INTEGER DEFAULT 0,
      read_at TEXT,
      deleted_at TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (message_id) REFERENCES ${DatabaseTables.messages} (id) ON DELETE CASCADE,
      FOREIGN KEY (recipient_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE
    )
  ''';

  // Message Threads table
  static const String messageThreads =
      '''
    CREATE TABLE ${DatabaseTables.messageThreads} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      title TEXT,
      thread_type TEXT CHECK(thread_type IN ('direct', 'group', 'course', 'class', 'announcement')) NOT NULL,
      course_offering_id TEXT,
      last_message_id TEXT,
      last_message_at TEXT,
      created_by TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (course_offering_id) REFERENCES ${DatabaseTables.courseOfferings} (id) ON DELETE SET NULL,
      FOREIGN KEY (last_message_id) REFERENCES ${DatabaseTables.messages} (id) ON DELETE SET NULL,
      FOREIGN KEY (created_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE
    )
  ''';

  // Message Thread Members table
  static const String messageThreadMembers =
      '''
    CREATE TABLE ${DatabaseTables.messageThreadMembers} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      thread_id TEXT NOT NULL,
      user_id TEXT NOT NULL,
      is_admin INTEGER DEFAULT 0,
      muted INTEGER DEFAULT 0,
      left_at TEXT,
      added_by TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (thread_id) REFERENCES ${DatabaseTables.messageThreads} (id) ON DELETE CASCADE,
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE,
      FOREIGN KEY (added_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE,
      UNIQUE(thread_id, user_id)
    )
  ''';

  // Indexes for better query performance
  static const List<String> indexes = [
    'CREATE INDEX IF NOT EXISTS idx_messages_sender_receiver ON ${DatabaseTables.messages}(sender_id, receiver_id)',
    'CREATE INDEX IF NOT EXISTS idx_messages_course_offering ON ${DatabaseTables.messages}(course_offering_id)',
    'CREATE INDEX IF NOT EXISTS idx_message_attachments_message ON ${DatabaseTables.messageAttachments}(message_id)',
    'CREATE INDEX IF NOT EXISTS idx_announcements_dates ON ${DatabaseTables.announcements}(start_date, end_date)',
    'CREATE INDEX IF NOT EXISTS idx_announcement_recipients_announcement ON ${DatabaseTables.announcementRecipients}(announcement_id)',
    'CREATE INDEX IF NOT EXISTS idx_notifications_user ON ${DatabaseTables.notifications}(user_id, is_read)',
    'CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON ${DatabaseTables.notifications}(created_at)',
    'CREATE INDEX IF NOT EXISTS idx_message_recipients_message ON ${DatabaseTables.messageRecipients}(message_id)',
    'CREATE INDEX IF NOT EXISTS idx_message_recipients_recipient ON ${DatabaseTables.messageRecipients}(recipient_id, is_read)',
    'CREATE INDEX IF NOT EXISTS idx_message_threads_last_message ON ${DatabaseTables.messageThreads}(last_message_at)',
    'CREATE INDEX IF NOT EXISTS idx_message_threads_course ON ${DatabaseTables.messageThreads}(course_offering_id)',
    'CREATE INDEX IF NOT EXISTS idx_message_thread_members_thread ON ${DatabaseTables.messageThreadMembers}(thread_id)',
    'CREATE INDEX IF NOT EXISTS idx_message_thread_members_user ON ${DatabaseTables.messageThreadMembers}(user_id)',
  ];

  // All table definitions (no indexes)
  static const List<String> all = [
    messages,
    messageAttachments,
    announcements,
    announcementRecipients,
    notifications,
    messageRecipients,
    messageThreads,
    messageThreadMembers,
  ];

  // DEPRECATED: Use CommunicationSchemas.all for tables and CommunicationSchemas.indexes separately
  // This method is kept for backward compatibility but should not be used in new code
  @deprecated
  static Future<List<String>> get allWithIndexes async {
    // Simply return tables without indexes
    // Indexes should be created separately via the indexes list
    return List<String>.from(all);
  }
}
