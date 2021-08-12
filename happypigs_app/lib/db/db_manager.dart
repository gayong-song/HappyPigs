import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'Plate.dart';
import 'PlateType.dart';
import 'Tag.dart';
import 'User.dart';
import 'package:happypigs_app/util.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper.internal();

  factory DBHelper() => _instance;

  static Database _db;
  bool _isDebug = true;

  String userTable = "User";
  String plateTable = "Plate";
  String plateGroupTable = "PlateGroup";
  String plateTypeTable = "PlateType";
  String tagsTable = "Tags";

  // r prefix means "relation"
  String rPlateImgTable = "Plate_Img_Path";
  String rPlateTypeGroupTable = "PlateType_Group";
  String rItemTagTable = "Items_Tags";

  Future<Database> get database async {
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

  Future initTable() async {
    await _createDb();
  }

  /// Count number of tables in DB
  Future countTable() async {
    var dbClient = await database;
    var res =
        await dbClient.rawQuery("""SELECT count(*) as count FROM sqlite_master
         WHERE type = 'table' 
         AND name != 'android_metadata' 
         AND name != 'sqlite_sequence';""");
    logger.d("count :  ${res[0]['count']}");
    return res[0]['count'];
  }

  Future<void> _createDb() async {
    var dbClient = await database;
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
    await db.execute('''create table IF NOT EXISTS $userTable (
         name text default piggy
       )''');
  }

  Future<void> _createPlateImgPathTable(Database db) async {
    await db.execute('''create table IF NOT EXISTS $rPlateImgTable (
          imgPathId integer primary key autoincrement not null,
          plateId integer not null,
          path text not null,
          FOREIGN KEY(plateId) REFERENCES $plateTable(plateId)
         )''');
  }

  Future<void> _createPlateGroupTable(Database db) async {
    await db.execute('''create table if not exists $plateGroupTable (
    plateGroupId integer primary key autoincrement not null,
    title text
    )''');
  }

  Future<void> _createPlateTypeTable(Database db) async {
    await db.execute('''create table if not exists $plateTypeTable (
    plateTypeId integer primary key autoincrement not null,
    imgPath text not null,
    plateGroupId integer not null,
    FOREIGN KEY(plateGroupId) REFERENCES $plateGroupTable(plateGroupId)
   )''');
  }

  Future<void> _createPlateTable(Database db) async {
    await db.execute('''create table IF NOT EXISTS $plateTable (
          plateId integer primary key autoincrement not null,
          whereToEat text not null,
          whenToEat datetime not null,
          description text not null,
          rating integer not null,
          plateTypeId integer not null,
          FOREIGN KEY(plateTypeId) REFERENCES $plateTypeTable(plateTypeId)
         )''');
  }

  Future<void> _createPlateTypesGroupTable(Database db) async {
    await db.execute('''create table if not exists $rPlateTypeGroupTable (
    plateGroupId integer not null,
    createPlateTypeTable integer not null,
    FOREIGN KEY(plateGroupId) REFERENCES $plateGroupTable(plateGroupId),
    FOREIGN KEY(createPlateTypeTable) REFERENCES $plateTypeTable(createPlateTypeTable)
   )''');
  }

  Future<void> _createTagTable(Database db) async {
    await db.execute('''create table if not exists $tagsTable (
    tagId integer primary key autoincrement not null,
    name text not null
   )''');
  }

  Future<void> _createItemsTagsTable(Database db) async {
    await db.execute('''create table if not exists $rItemTagTable (
    tagId integer not null,
    plateId integer not null,
    FOREIGN KEY(tagId) REFERENCES $tagsTable(tagId),
    FOREIGN KEY(plateId) REFERENCES $plateTable(plateId)
   )''');
  }

  // Define a function that inserts User into the database
  Future<void> insertUser(User user) async {
    // Insert the User into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    var dbClient = await database;
    await dbClient.insert(
      userTable,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Define a function that inserts Plate into the database
  Future<void> insertPlate(Plate plate) async {
    var dbClient = await database;
    await dbClient.insert(
      plateTable,
      plate.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    var resultSet = await dbClient.rawQuery(
        "SELECT * FROM $plateTable WHERE plateId=(SELECT max(plateId) FROM $plateTable)");
    var dbItem = resultSet.first;
    plate.plateId = dbItem['plateId'] as int;
    logger.d("Put id to plate ${plate.plateId}");

    for (var imgPath in plate.imgPaths) {
      await dbClient.insert(
        rPlateImgTable,
        {'path': imgPath, 'plateId': plate.plateId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    for (var tag_id in plate.tag_ids) {
      await dbClient.insert(
        rItemTagTable,
        {'tagId': tag_id, 'plateId': plate.plateId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Define a function that inserts PlateType into the database
  Future<void> insertPlateType(PlateType plate_type) async {
    var dbClient = await database;
    await dbClient.insert(
      plateTypeTable,
      plate_type.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    var resultSet = await dbClient.rawQuery(
        "SELECT * FROM $plateTypeTable WHERE plateTypeId=(SELECT max(plateTypeId) FROM $plateTypeTable)");
    var dbItem = resultSet.first;
    plate_type.plateTypeId = dbItem['plateTypeId'] as int;
    logger.d("Put id to plate_type ${plate_type.plateTypeId}");
  }

  Future<void> insertTag(Tag tag) async {
    var dbClient = await database;
    await dbClient.insert(
      tagsTable,
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    var resultSet = await dbClient.rawQuery(
        "SELECT * FROM $tagsTable WHERE tagId=(SELECT max(tagId) FROM $tagsTable)");
    var dbItem = resultSet.first;
    tag.tagId = dbItem['tagId'] as int;
    logger.d("Put id to tag ${tag.tagId}");
  }

  Future<List<Map<String, dynamic>>> getData(String table_name) async {
    var dbClient = await database;
    return await dbClient.query(table_name);
  }

  Future<List<Map<String, dynamic>>> getPlateData(
      int plateId, String table_name) async {
    var dbClient = await database;
    return await dbClient
        .rawQuery("SELECT * FROM $table_name WHERE plateId=$plateId");
  }

  Future<List<Plate>> readPlates() async {
    final List<Map<String, dynamic>> maps = await getData(plateTable);
    List<Plate> plates = [];

    for (var pl in maps) {
      var imgPaths = await getPlateData(pl['plateId'], rPlateImgTable);
      var plateTags = await getPlateData(pl['plateId'], rItemTagTable);
      var plate = Plate(
          plateId: pl['plateId'],
          whereToEat: pl['whereToEat'],
          whenToEat: DateTime.parse(pl['whenToEat']),
          description: pl['description'],
          plateTypeId: pl['plateTypeId'],
          rating: pl['rating'],
          imgPaths: List.generate(imgPaths.length, (j) {
            return imgPaths[j]['path'];
          }),
          tag_ids: List.generate(plateTags.length, (k) {
            return plateTags[k]['tagId'];
          }));

      logger.d(plate);
      plates.add(plate);
    }
    ;
    return plates;
  }

  Future<List<PlateType>> readPlateTypes() async {
    // Todo: need to rename table below
    final List<Map<String, dynamic>> maps = await getData(plateTypeTable);

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
    final List<Map<String, dynamic>> maps = await getData(tagsTable);

    return List.generate(maps.length, (i) {
      return Tag(
        tagId: maps[i]['tagId'],
        name: maps[i]['name'],
      );
    });
  }

  Future<List<User>> readUser() async {
    // Todo: need to rename table below
    final List<Map<String, dynamic>> maps = await getData(userTable);

    return List.generate(maps.length, (i) {
      return User(
        name: maps[i]['name'],
      );
    });
  }
}
