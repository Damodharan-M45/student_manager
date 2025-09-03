import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static const _dbName = 'students.db';
  static const _dbVersion = 1;
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    _database = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
    return _database!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE students(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      userId TEXT NOT NULL,
      name TEXT NOT NULL,
      email TEXT NOT NULL,
      phone TEXT NOT NULL
    )
  ''');
  }
}
