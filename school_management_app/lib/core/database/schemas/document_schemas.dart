import 'package:school_management_app/core/database/database_tables.dart';

class DocumentSchemas {
  // Document Folders table
  static const String documentFolders = '''
    CREATE TABLE ${DatabaseTables.documentFolders} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      parent_id TEXT,
      name TEXT NOT NULL,
      description TEXT,
      path TEXT NOT NULL,
      is_system INTEGER DEFAULT 0,
      is_shared INTEGER DEFAULT 0,
      access_level TEXT CHECK(access_level IN ('private', 'public', 'restricted')) DEFAULT 'private',
      created_by TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (parent_id) REFERENCES ${DatabaseTables.documentFolders} (id) ON DELETE CASCADE,
      FOREIGN KEY (created_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE
    )
  ''';

  // Documents table
  static const String documents = '''
    CREATE TABLE ${DatabaseTables.documents} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      folder_id TEXT,
      name TEXT NOT NULL,
      description TEXT,
      file_name TEXT NOT NULL,
      file_url TEXT NOT NULL,
      file_size INTEGER NOT NULL,
      file_type TEXT NOT NULL,
      mime_type TEXT,
      version TEXT,
      is_latest INTEGER DEFAULT 1,
      is_public INTEGER DEFAULT 0,
      status TEXT CHECK(status IN ('draft', 'published', 'archived', 'deleted')) DEFAULT 'draft',
      metadata TEXT, -- JSON string for additional metadata
      created_by TEXT NOT NULL,
      updated_by TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (folder_id) REFERENCES ${DatabaseTables.documentFolders} (id) ON DELETE SET NULL,
      FOREIGN KEY (created_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE,
      FOREIGN KEY (updated_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE SET NULL
    )
  ''';

  // Course Materials table
  static const String courseMaterials = '''
    CREATE TABLE ${DatabaseTables.courseMaterials} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      course_offering_id TEXT NOT NULL,
      document_id TEXT NOT NULL,
      title TEXT NOT NULL,
      description TEXT,
      material_type TEXT CHECK(material_type IN ('lecture_notes', 'slides', 'reading', 'assignment', 'exam', 'other')) DEFAULT 'other',
      is_required INTEGER DEFAULT 0,
      available_from TEXT,
      available_until TEXT,
      sort_order INTEGER DEFAULT 0,
      created_by TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (course_offering_id) REFERENCES ${DatabaseTables.courseOfferings} (id) ON DELETE CASCADE,
      FOREIGN KEY (document_id) REFERENCES ${DatabaseTables.documents} (id) ON DELETE CASCADE,
      FOREIGN KEY (created_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE
    )
  ''';

  // Document Downloads table
  static const String documentDownloads = '''
    CREATE TABLE ${DatabaseTables.documentDownloads} (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      document_id TEXT NOT NULL,
      user_id TEXT NOT NULL,
      downloaded_at TEXT NOT NULL,
      ip_address TEXT,
      device_info TEXT,
      user_agent TEXT,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (document_id) REFERENCES ${DatabaseTables.documents} (id) ON DELETE CASCADE,
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE
    )
  ''';

  // Document Permissions table
  static const String documentPermissions = '''
    CREATE TABLE document_permissions (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      document_id TEXT,
      folder_id TEXT,
      user_id TEXT,
      role_id TEXT,
      permission_level TEXT CHECK(permission_level IN ('view', 'edit', 'manage', 'owner')) NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (document_id) REFERENCES ${DatabaseTables.documents} (id) ON DELETE CASCADE,
      FOREIGN KEY (folder_id) REFERENCES ${DatabaseTables.documentFolders} (id) ON DELETE CASCADE,
      FOREIGN KEY (user_id) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE,
      FOREIGN KEY (role_id) REFERENCES ${DatabaseTables.userRoles} (id) ON DELETE CASCADE,
      CHECK (document_id IS NOT NULL OR folder_id IS NOT NULL),
      CHECK (user_id IS NOT NULL OR role_id IS NOT NULL)
    )
  ''';

  // Document Versions table
  static const String documentVersions = '''
    CREATE TABLE document_versions (
      id TEXT PRIMARY KEY,
      university_id TEXT NOT NULL,
      document_id TEXT NOT NULL,
      version_number TEXT NOT NULL,
      file_name TEXT NOT NULL,
      file_url TEXT NOT NULL,
      file_size INTEGER NOT NULL,
      file_type TEXT NOT NULL,
      mime_type TEXT,
      change_log TEXT,
      created_by TEXT NOT NULL,
      created_at TEXT NOT NULL,
      sync_status TEXT DEFAULT 'synced',
      sync_version INTEGER DEFAULT 1,
      is_dirty INTEGER DEFAULT 0,
      last_synced_at TEXT,
      conflict_data TEXT,
      FOREIGN KEY (university_id) REFERENCES ${DatabaseTables.universities} (id) ON DELETE CASCADE,
      FOREIGN KEY (document_id) REFERENCES ${DatabaseTables.documents} (id) ON DELETE CASCADE,
      FOREIGN KEY (created_by) REFERENCES ${DatabaseTables.users} (id) ON DELETE CASCADE,
      UNIQUE(document_id, version_number)
    )
  ''';

  // Indexes for better query performance
  static const List<String> indexes = [
    'CREATE INDEX idx_documents_folder ON ${DatabaseTables.documents}(folder_id)',
    'CREATE INDEX idx_documents_created_by ON ${DatabaseTables.documents}(created_by)',
    'CREATE INDEX idx_document_folders_parent ON ${DatabaseTables.documentFolders}(parent_id)',
    'CREATE INDEX idx_course_materials_course ON ${DatabaseTables.courseMaterials}(course_offering_id)',
    'CREATE INDEX idx_document_downloads_document ON ${DatabaseTables.documentDownloads}(document_id)',
    'CREATE INDEX idx_document_downloads_user ON ${DatabaseTables.documentDownloads}(user_id)',
    'CREATE INDEX idx_document_permissions_document ON document_permissions(document_id)',
    'CREATE INDEX idx_document_permissions_folder ON document_permissions(folder_id)',
    'CREATE INDEX idx_document_versions_document ON document_versions(document_id)',
  ];

  // All schema definitions
  static const List<String> all = [
    documentFolders,
    documents,
    courseMaterials,
    documentDownloads,
    documentPermissions,
    documentVersions,
    ...indexes,
  ];
}
