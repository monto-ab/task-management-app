import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class TaskRepository {
  static final TaskRepository _instance = TaskRepository._internal();
  factory TaskRepository() => _instance;
  TaskRepository._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
     CREATE TABLE IF NOT EXISTS "tasks" (
      "id"	INTEGER NOT NULL,
      "title" TEXT,
      "description" TEXT,
      "isCompleted" INTEGER NOT NULL DEFAULT 0,
      PRIMARY KEY("id" AUTOINCREMENT)
      )
    ''');
  }

  Future<int> insertTask(
      {required String title, required String description}) async {
    final db = await database;
    return await db.insert(
        'tasks', {'title': title, 'description': description},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task.fromJson(maps[i]);
    });
  }
}
