import 'package:sqflite/sqflite.dart';

import '../model/task_model.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'tasks.db';
  static const _databaseVersion = 1;

  static const table = 'tasks';
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDate = 'date';
  static const columnStatus = 'status';

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    // Get the location of the database
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Create the tasks table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnTitle TEXT NOT NULL,
        $columnDate TEXT NOT NULL,
        $columnStatus TEXT NOT NULL
      )
    ''');
  }

  // Insert a task into the database
  Future<int> insertTask(Task task) async {
    Database db = await instance.database;
    return await db.insert(table, task.toMap());
  }

  // Get all tasks from the database
  Future<List<Task>> getTasks() async {
    Database db = await instance.database;
    var tasks = await db.query(table);
    List<Task> taskList = tasks.isNotEmpty
        ? tasks.map((task) => Task.fromMap(task)).toList()
        : [];
    return taskList;
  }

  // Update a task
  Future<int> updateTask(Task task) async {
    Database db = await instance.database;
    return await db.update(table, task.toMap(),
        where: '$columnId = ?', whereArgs: [task.id]);
  }

  // Delete a task
  Future<int> deleteTask(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
