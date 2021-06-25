

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void init_db() async{
  // 데이터베이스를 열고 참조 값을 얻습니다.
  // final Future<Database> database = openDatabase(
  //   // 데이터베이스 경로를 지정합니다. 참고: `path` 패키지의 `join` 함수를 사용하는 것이
  //   // 각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법입니다.
  //     join(await getDatabasesPath(), 'doggie_database.db'),
  // );

  final Future<Database> database = openDatabase(
    // 데이터베이스 경로를 지정합니다.
    join(await getDatabasesPath(), 'doggie_database.db'),
    // 데이터베이스가 처음 생성될 때, dog를 저장하기 위한 테이블을 생성합니다.
    onCreate: (db, version) {
      // 데이터베이스에 CREATE TABLE 수행
      return db.execute(
        "CREATE TABLE plate(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
      );
    },
    // 버전을 설정하세요. onCreate 함수에서 수행되며 데이터베이스 업그레이드와 다운그레이드를
    // 수행하기 위한 경로를 제공합니다.
    version: 1,
  );
}