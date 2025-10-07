import 'dart:async';
import 'package:sqflite/sqflite.dart';

/// Interface for database operations
abstract class DatabaseService {
  /// Initializes the database
  Future<Database> get database;

  /// Closes the database
  Future<void> close();

  /// Executes a raw SQL query
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]);

  /// Inserts a row in the database
  Future<int> insert(String table, Map<String, dynamic> row);

  /// Queries the database
  Future<List<Map<String, dynamic>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  });

  /// Updates a row in the database
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  });

  /// Deletes a row from the database
  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  });

  /// Executes a batch of operations
  Future<void> batchWrite(Function(Batch) operations);
}
