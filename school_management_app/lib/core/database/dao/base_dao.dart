import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';

abstract class BaseDao<T> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  String get tableName;

  /// Converts a Map from the database to a model object
  T fromMap(Map<String, dynamic> map);

  /// Converts a model object to a Map for the database
  Map<String, dynamic> toMap(T item);

  /// Inserts a new item into the database
  Future<String> insert(T item) async {
    final db = await _dbHelper.database;
    final id = await db.insert(tableName, toMap(item));
    return id.toString();
  }

  /// Updates an existing item in the database
  Future<int> update(T item, String id) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableName,
      toMap(item),
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Deletes an item from the database
  Future<int> delete(String id) async {
    final db = await _dbHelper.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  /// Retrieves an item by its ID
  Future<T?> getById(String id) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return fromMap(maps.first);
    }
    return null;
  }

  /// Retrieves all items from the table
  Future<List<T>> getAll() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => fromMap(maps[i]));
  }

  /// Retrieves items with pagination
  Future<List<T>> getPaginated({
    int limit = 10,
    int offset = 0,
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
  }) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );

    return List.generate(maps.length, (i) => fromMap(maps[i]));
  }

  /// Counts the number of items matching the given conditions
  Future<int> count({String? where, List<dynamic>? whereArgs}) async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName${where != null ? ' WHERE $where' : ''}',
      whereArgs,
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Executes a custom query and returns the results
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    final db = await _dbHelper.database;
    return await db.rawQuery(sql, arguments);
  }

  /// Executes a custom update/insert/delete query
  Future<int> rawUpdate(String sql, [List<dynamic>? arguments]) async {
    final db = await _dbHelper.database;
    return await db.rawUpdate(sql, arguments);
  }

  /// Begins a database transaction
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    final db = await _dbHelper.database;
    return await db.transaction(action);
  }
}
