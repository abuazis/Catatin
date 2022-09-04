import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../../models/md_course_model.dart';

class MdCourseDatabaseHelper {
  static MdCourseDatabaseHelper? _databaseHelper;

  MdCourseDatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory MdCourseDatabaseHelper() 
  => _databaseHelper ?? MdCourseDatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _mdCourseTable = 'mdCourseTable';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/md_course.db';

    final db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_mdCourseTable (
        id INTEGER PRIMARY KEY,
        name TEXT,
        url TEXT,
        path TEXT,
        createdAt TEXT
      );
    ''');
  }

  Future<int> insertMdCourse(MdCourseModel course) async {
    final db = await database;
    return await db!.insert(_mdCourseTable, course.toMap());
  }

  Future<int> removeMdCourse(MdCourseModel course) async {
    final db = await database;
    return await db!.delete(
      _mdCourseTable,
      where: 'id = ?',
      whereArgs: [course.id],
    );
  }

  Future<Map<String, dynamic>?> getMdCourseById(int id) async {
    final db = await database;
    final results = await db!.query(
      _mdCourseTable,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getMdCourses() async {
    final db = await database;
    final results = await db!.query(_mdCourseTable);
    return results;
  }
}