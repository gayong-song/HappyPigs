import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> database;

void init_db() async {
  await deleteDatabase(join(await getDatabasesPath(), 'happy_database.db'));
  database = openDatabase(
    // 데이터베이스 경로를 지정합니다.
    join(await getDatabasesPath(), 'happy_database.db'),
    // 데이터베이스가 처음 생성될 때, dog를 저장하기 위한 테이블을 생성합니다.
    onCreate: (db, version) async {
      await createUserTable(db);
      await createPlateTable(db);
      await createPlateImgPathTable(db);
      await createPlateTypeTable(db);
      await createTagTable(db);
      await createItemsTagsTable(db);
    },
    version: 1
  );
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

Future<void> printDatabase() async {
  final Database db = await database;
  print("is Open ? ${db.isOpen}");
  print("is Open ? ${db.path}");
  print("is Open ? ${db.rawQuery("SELECT * FROM Plate")}");
  print("is Open ? ${db.rawQuery("SELECT * FROM Plate_Img_Path")}");
  print("is Open ? ${db.rawQuery("SELECT name FROM User")}");
  print("is Open ? ${db.rawQuery("SELECT * FROM PlateType")}");
  print("is Open ? ${db.rawQuery("SELECT * FROM Tags")}");
  print("is Open ? ${db.rawQuery("SELECT * FROM Items_Tags")}");
}
