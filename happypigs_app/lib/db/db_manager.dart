import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'Plate.dart';
import 'PlateType.dart';
import 'Tag.dart';
import 'User.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper.internal();
  factory DBHelper() => _instance;

  static Database _db;
  bool _isDebug = true;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DBHelper.internal();

  /// Initialize DB
  initDb() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "happy_database.db");
    if (_isDebug) await deleteDatabase(path);
    var taskDb = await openDatabase(path, version: 1);
    return taskDb;
  }

  Future initTable() async{
    await _createDb();
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

  Future<void> _createDb() async {
    var dbClient = await db;
    await _createUserTable(dbClient);
    await _createTagTable(dbClient);
    await _createPlateGroupTable(dbClient);
    await _createPlateTypeTable(dbClient);
    await _createPlateTable(dbClient);
    await _createPlateImgPathTable(dbClient);
    await _createItemsTagsTable(dbClient);
    await _createPlateTypesGroupTable(dbClient);
    await countTable();
  }

  Future<void> _createUserTable(Database db) async {
    await db.execute('''create table IF NOT EXISTS User (
         name text default piggy
       )''');
  }

  Future<void> _createPlateImgPathTable(Database db) async {
    await db.execute('''create table IF NOT EXISTS Plate_Img_Path (
          imgPathId integer primary key autoincrement not null,
          plateId integer not null,
          path text not null,
          FOREIGN KEY(plateId) REFERENCES Plate(plateId)
         )''');
  }

  Future<void> _createPlateGroupTable(Database db) async {
    await db.execute('''create table if not exists PlateGroup (
    plateGroupId integer primary key autoincrement not null,
    title text
    )''');
  }

  Future<void> _createPlateTypeTable(Database db) async {
    await db.execute('''create table if not exists PlateType (
    plateTypeId integer primary key autoincrement not null,
    imgPath text not null,
    plateGroupId integer not null,
    FOREIGN KEY(plateGroupId) REFERENCES PlateGroup(plateGroupId)
   )''');
  }

  Future<void> _createPlateTable(Database db) async {
    await db.execute('''create table IF NOT EXISTS Plate (
          plateId integer primary key autoincrement not null,
          whereToEat text not null,
          whenToEat datetime not null,
          description text not null,
          rating integer not null,
          plateTypeId integer not null,
          FOREIGN KEY(plateTypeId) REFERENCES PlateType(plateTypeId)
         )''');
  }

  Future<void> _createPlateTypesGroupTable(Database db) async {
    await db.execute('''create table if not exists PlateType_Group (
    plateGroupId integer not null,
    createPlateTypeTable integer not null,
    FOREIGN KEY(plateGroupId) REFERENCES PlateGroup(plateGroupId),
    FOREIGN KEY(createPlateTypeTable) REFERENCES PlateType(createPlateTypeTable)
   )''');
  }

  Future<void> _createTagTable(Database db) async {
    await db.execute('''create table if not exists Tags (
    tagId integer primary key autoincrement not null,
    name text not null
   )''');
  }

  Future<void> _createItemsTagsTable(Database db) async {
    await db.execute('''create table if not exists Items_Tags (
    tagId integer not null,
    plateId integer not null,
    FOREIGN KEY(tagId) REFERENCES Tags(tagId),
    FOREIGN KEY(plateId) REFERENCES Plate(plateId)
   )''');
  }

  // Define a function that inserts User into the database
  Future<void> insertUser(User user) async {
    // Insert the User into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await _db.insert(
      // Todo : need to rename user table below
      'User',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Define a function that inserts Plate into the database
  Future<void> insertPlate(Plate plate) async {
    await _db.insert(
      // Todo : need to rename plate table below
      'Plate',
      plate.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Define a function that inserts PlateType into the database
  Future<void> insertPlateType(PlateType plate_type) async {
    await _db.insert(
      // Todo : need to rename platetype table below
      'PlateType',
      plate_type.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Define a function that inserts PlateType into the database
  Future<void> insertTag(Tag tag) async {
    await _db.insert(
      // Todo : need to rename tag table below
      'Tags',
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getData(String table_name) async {
    return await _db.query(table_name);
  }

  Future<List<Plate>> readPlates() async {
    // Todo: need to rename table below
    final List<Map<String, dynamic>> maps = await getData('Plate');

    return List.generate(maps.length, (i) {
      return Plate(
        plateId: maps[i]['plateId'],
        whereToEat: maps[i]['whereToEat'],
        whenToEat: DateTime.parse(maps[i]['whenToEat']),
        description: maps[i]['description'],
        rating: maps[i]['rating'],
        plateTypeId: maps[i]['plateTypeId'],
      );
    });
  }

  Future<List<PlateType>> readPlateTypes() async {
    // Todo: need to rename table below
    final List<Map<String, dynamic>> maps = await getData('PlateType');

    return List.generate(maps.length, (i) {
      return PlateType(
        plateTypeId: maps[i]['plateTypeId'],
        imgPath: maps[i]['imgPath'],
        plateGroupId: maps[i]['plateGroupId'],
      );
    });
  }

  Future<List<Tag>> readTags() async {
    // Todo: need to rename table below
    final List<Map<String, dynamic>> maps = await getData('Tags');

    return List.generate(maps.length, (i) {
      return Tag(
        tagId: maps[i]['tagId'],
        name: maps[i]['name'],
      );
    });
  }

  Future<List<User>> readUser() async {
    // Todo: need to rename table below
    final List<Map<String, dynamic>> maps = await getData('User');

    return List.generate(maps.length, (i) {
      return User(
        name: maps[i]['name'],
      );
    });
  }
}
