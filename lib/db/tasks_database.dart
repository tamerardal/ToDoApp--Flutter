import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_application/model/task.dart';

class TasksDatabase {
  static final TasksDatabase instance = TasksDatabase._init();
  static Database? _database;
  TasksDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
CREATE TABLE $tableTask (
  ${TaskFields.id} $idType,
  ${TaskFields.title} $textType,
  ${TaskFields.description} $textType,
  ${TaskFields.time} $textType,
  ${TaskFields.done} $boolType
  )
''');
  }

  Future<Task> create(Task task) async {
    final db = await instance.database;

    final id = await db.insert(tableTask, task.toJson());
    return task.copy(id: id);
  }

  Future<Task> readTask(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableTask,
      columns: TaskFields.values,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found!');
    }
  }

  Future<List<Task>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${TaskFields.time} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableTask, orderBy: orderBy);

    return result.map((json) => Task.fromJson(json)).toList();
  }

  // Future<int> update(Task task) async {
  //   final db = await instance.database;

  //   return db.update(
  //     tableNotes,
  //     note.toJson(),
  //     where: '${NoteFields.id} = ?',
  //     whereArgs: [note.id],
  //   );
  // }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableTask,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
