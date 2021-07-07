import 'package:flutter/material.dart';

import 'db/db_manager.dart';
import 'db/sqlite_manager.dart';
import 'happy_main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize sq-lite
  final db = SqliteDB();
  await db.countTable();
  await init_db();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HappyMainPage(),
    );
  }
}
