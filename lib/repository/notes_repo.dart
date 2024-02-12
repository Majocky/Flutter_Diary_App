import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqliteflutter/models/note.dart';

class NotesRepository {
  static const _dbName = 'notes_database.db';
  static const _tablename = 'notes';

  static Future<Database> _database() async {
    final database = openDatabase(
      join(await getDatabasesPath(), '$_dbName'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_tablename(id INTEGER PRIMARY KEY, title TEXT, description TEXT,createdAt TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  static insert({required Note note}) async {
    final db = await _database();
    await db.insert(
      _tablename,
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Note>> getNotes() async {
    final db = await _database();

    final List<Map<String, dynamic>> maps = await db.query(_tablename);
    return List.generate(maps.length, (i) {
      return Note(
          id: maps[i]['id'] as int,
          title: maps[i]['title'] as String,
          description: maps[i]['description'] as String,
          createdAt: DateTime.parse(maps[i]["createdAt"]));
    });
  }

  static updateNote({required Note note}) async {
    final db = await _database();
    await db.update(
      _tablename,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static delete({required Note note}) async {
    final db = await _database();
    await db.delete(
      _tablename,
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }
}
