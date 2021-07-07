import "dart:io" as io;
import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class SqliteDB {
  static final SqliteDB _instance = new SqliteDB.internal();

  factory SqliteDB() => _instance;
  static Database _db;
  bool _isDebug = true;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  SqliteDB.internal();

  /// Initialize DB
  initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "happy_database.db");
    if (_isDebug) await deleteDatabase(path);
    var taskDb = await openDatabase(path, version: 1);
    return taskDb;
  }

  /// Count number of tables in DB
  Future countTable() async {
    var dbClient = await db;
    var res =
        await dbClient.rawQuery("""SELECT count(*) as count FROM sqlite_master
         WHERE type = 'table' 
         AND name != 'android_metadata' 
         AND name != 'sqlite_sequence';""");
    print("count :  ${res[0]['count']}");
    return res[0]['count'];
  }
}
