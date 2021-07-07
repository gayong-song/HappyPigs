import 'package:happypigs_app/db/sqlite_manager.dart';
import 'package:sqflite/sqflite.dart';

void init_db() async {
  final sqliteDb = await SqliteDB();
  Database db = await sqliteDb.db;
  await createUserTable(db);
  await createTagTable(db);
  await createPlateGroupTable(db);
  await createPlateTypeTable(db);
  await createPlateTable(db);
  await createPlateImgPathTable(db);
  await createItemsTagsTable(db);
  await createPlateTypesGroupTable(db);
  await sqliteDb.countTable();
}

Future<void> createUserTable(Database db) async {
  await db.execute('''create table IF NOT EXISTS User (
         name text default piggy
       )''');
}

Future<void> createPlateImgPathTable(Database db) async {
  await db.execute('''create table IF NOT EXISTS Plate_Img_Path (
          imgPathId integer primary key autoincrement not null,
          plateId integer not null,
          path text not null,
          FOREIGN KEY(plateId) REFERENCES Plate(plateId)
         )''');
}

Future<void> createPlateGroupTable(Database db) async {
  await db.execute('''create table if not exists PlateGroup (
    plateGroupId integer primary key autoincrement not null,
    title text
    )''');
}

Future<void> createPlateTypeTable(Database db) async {
  await db.execute('''create table if not exists PlateType (
    plateTypeId integer primary key autoincrement not null,
    imgPath text not null,
    plateGroupId integer not null,
    FOREIGN KEY(plateGroupId) REFERENCES PlateGroup(plateGroupId)
   )''');
}

Future<void> createPlateTable(Database db) async {
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

Future<void> createPlateTypesGroupTable(Database db) async {
  await db.execute('''create table if not exists PlateType_Group (
    plateGroupId integer not null,
    createPlateTypeTable integer not null,
    FOREIGN KEY(plateGroupId) REFERENCES PlateGroup(plateGroupId),
    FOREIGN KEY(createPlateTypeTable) REFERENCES PlateType(createPlateTypeTable)
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
    plateId integer not null,
    FOREIGN KEY(tagId) REFERENCES Tags(tagId),
    FOREIGN KEY(plateId) REFERENCES Plate(plateId)
   )''');
}
