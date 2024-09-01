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
      "date" INTEGER ,
      PRIMARY KEY("id" AUTOINCREMENT)
      )
    ''');
  }

  Future<int> insertTask(
      {required String title,
      required String description,
      int? dateInMillis}) async {
    final db = await database;
    return await db.insert('tasks',
        {'title': title, 'description': description, 'date': dateInMillis},
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
    List<Task> list = List.generate(maps.length, (i) {
      return Task.fromJson(maps[i]);
    });

    list.sort((a, b) {
      if (a.date == null && b.date == null) return 0;
      if (a.date == null) return 1;
      if (b.date == null) return -1;
      return a.date!.compareTo(b.date!);
    });

    return list;
  }
}
