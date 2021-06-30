import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Plate.dart';
import 'PlateType.dart';
import 'Tag.dart';
import 'User.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  var _db;

  factory DBHelper(){
    return _instance;
  }

  DBHelper._internal(){
    _deleteDb();
    printDatabase();
  }

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = openDatabase(
      join(await getDatabasesPath(), 'happy_database.db'),
      onCreate: (db, version) => _createDb(db),
      version: 1,
    );
    return _db;
  }

  Future<void> _createDb(Database db) async {
    await createUserTable(db);
    await createPlateTable(db);
    await createPlateImgPathTable(db);
    await createPlateTypeTable(db);
    await createTagTable(db);
    await createItemsTagsTable(db);
  }

  Future<void> createUserTable(Database db) async {
    await db.execute('''create table User (
          name text default piggy
        )''');
  }

  Future<void> createPlateTable(Database db) async {
    await db.execute('''create table IF NOT EXISTS Plate (
           plateId integer primary key autoincrement not null,
           whereToEat text not null,
           whenToEat datetime not null,
           description text not null,
           rating integer not null,
           plateTypeId integer default 0
          )''');
  }

  Future<void> createPlateImgPathTable(Database db) async {
    await db.execute('''create table IF NOT EXISTS Plate_Img_Path (
           imgPathId integer primary key autoincrement not null,
           plateId integer not null,
           path text not null
          )''');
  }

  Future<void> createPlateTypeTable(Database db) async {
    await db.execute('''create table if not exists PlateType (
     plateTypeId integer primary key autoincrement not null,
     imgPath text not null,
     plateGroupId integer not null
    )''');
  }

  Future<void> createTagTable(Database db) async {
    await db.execute('''create table if not exists Tags (
     tagId integer primary key autoincrement not null,
     name text not null
    )''');
  }

  Future<void> createItemsTagsTable(Database db) async {
    await db.execute('''create table if not exists Items_Tags (
     tagId integer not null,
     plateId integer not null
    )''');
  }

  void _deleteDb() async {
    await deleteDatabase(join(await getDatabasesPath(), 'happy_database.db'));
  }

  Future<void> printDatabase() async {
    final Database db = await database;
    print("is Open ? ${db.isOpen}");
    print("is Open ? ${db.path}");
    print("is Open ? ${db.rawQuery("SELECT * FROM Plate")}");
    print("is Open ? ${db.rawQuery("SELECT * FROM Plate_Img_Path")}");
    print("is Open ? ${db.rawQuery("SELECT * FROM User")}");
    print("is Open ? ${db.rawQuery("SELECT * FROM PlateType")}");
    print("is Open ? ${db.rawQuery("SELECT * FROM Tags")}");
    print("is Open ? ${db.rawQuery("SELECT * FROM Items_Tags")}");
  }

  // Define a function that inserts User into the database
  Future<void> insertUser(User user) async {
    final Database db = await database;

    // Insert the User into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      // Todo : need to rename user table below
      'User',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Define a function that inserts Plate into the database
  Future<void> insertPlate(Plate plate) async {
    final Database db = await database;

    await db.insert(
      // Todo : need to rename plate table below
      'Plate',
      plate.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Define a function that inserts PlateType into the database
  Future<void> insertPlateType(PlateType plate_type) async {
    final Database db = await database;

    await db.insert(
      // Todo : need to rename platetype table below
      'PlateType',
      plate_type.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// Define a function that inserts PlateType into the database
  Future<void> insertTag(Tag tag) async {
    final Database db = await database;

    await db.insert(
      // Todo : need to rename tag table below
      'Tags',
      tag.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getData(String table_name) async {
    final Database db = await database;
    return db.query(table_name);
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
