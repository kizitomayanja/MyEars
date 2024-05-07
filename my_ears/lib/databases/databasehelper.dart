import 'package:my_ears/databases/files.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
//import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "File.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE Files(id INTEGER PRIMARY KEY, title TEXT NOT NULL, file TEXT NOT NULL, filepath TEXT NOT NULL)"),
        version: _version);
  }

  static Future<int> addFiles(Files file) async {
    final db = await _getDB();
    return await db.insert("Files", file.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateFiles(Files file) async {
    final db = await _getDB();
    return await db.update("Files", file.toJson(),
        where: 'id=?',
        whereArgs: [file.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteFiles(Files file) async {
    final db = await _getDB();
    return await db.delete(
      "Files",
      where: 'id=?',
      whereArgs: [file.id],
    );
  }

  static Future<List<Files>?> getAllFiles() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Files");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) {
      var file = Files.fromJson(maps[index]);
      // Ensure filepath is set based on stored value
      file.filepath = maps[index]['filepath'];
      return file;
    });
  }
}
