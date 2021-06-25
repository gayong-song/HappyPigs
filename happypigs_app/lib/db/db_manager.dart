import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> database;

void init_db() async {
  await deleteDatabase(join(await getDatabasesPath(), 'happy_database.db'));

  database = openDatabase(
    // 데이터베이스 경로를 지정합니다.
    join(await getDatabasesPath(), 'happy_database.db'),
    // 데이터베이스가 처음 생성될 때, dog를 저장하기 위한 테이블을 생성합니다.
    onCreate: (db, version) async{
      //Plate Table
      // await db.execute('''create table User (
      //    name text default piggy
      //  )''',
      // );
      await db.execute('''create table Plate (
        plateId integer primary key autoincrement not null,
        whereToEat text not null,
        whenToEat datetime not null,
        description text not null,
        rating integer not null,
        plateTypeId integer default 0
       )''',
      );
      // //PlateType
      // await db.execute('''create table PlateType (
      //   plateTypeId integer primary key autoincrement not null,
      //   imgPath text not null,
      //   plateGroupId integer not null
      //  )''',
      // );
      //Tag
      //User

    },
    version: 1,
  );
}

Future<void> printDatabase() async{
  final Database db = await database;
  await print("is Open ? ${db.isOpen}");
  await print("is Open ? ${db.path}");
  await print("is Open ? ${db.rawQuery("SELECT * FROM Plate")}");
}