import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_ears/databases/sessions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CalendarDatabase {
  static const int _version = 1;
  static const String _dbName = "Calendar.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) async => await db.execute(
            "CREATE TABLE Calendar(id INTEGER PRIMARY KEY, title TEXT NOT NULL, date TEXT NOT NULL, startHour TEXT NOT NULL, endHour TEXT NOT NULL)"),
        version: _version);
  }

  static Future<int> addFiles(Sessions session) async {
    final db = await _getDB();
    return await db.insert("Calendar", session.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updateFiles(Sessions session) async {
    final db = await _getDB();
    return await db.update("Calendar", session.toJson(),
        where: 'id=?',
        whereArgs: [session.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteFiles(Sessions session) async {
    final db = await _getDB();
    return await db.delete(
      "Calendar",
      where: 'id=?',
      whereArgs: [session.id],
    );
  }

  static Future<List<Sessions>?> getDateSessions(String date) async {
    final db = await _getDB();
    final List<Map<String, dynamic>> maps =
        await db.rawQuery("SELECT * FROM Calendar WHERE date=='$date'");
    if (maps.isEmpty) {
      return null;
    }
    return List.generate(
        maps.length, (index) => Sessions.fromJson(maps[index]));
  }

  static Future<List<String>?> getUniqueDates() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT DISTINCT date FROM Calendar');

    if (maps.isEmpty) {
      return null;
    }
    // Fluttertoast.showToast(msg: "there are unique dates");
    return List.generate(maps.length, (index) => maps[index]['date']);
  }

  static Future<List<Sessions>?> getAllFiles() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Calendar");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(
        maps.length, (index) => Sessions.fromJson(maps[index]));
  }
}
