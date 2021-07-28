import 'package:flutter/material.dart';
import 'package:happypigs_app/addPlatePage.dart';
import 'package:happypigs_app/addScorePage.dart';
import 'package:happypigs_app/db/db_manager.dart';
import 'package:happypigs_app/welcomePage.dart';

import 'happy_main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /// Initialize sq-lite
  final db = DBHelper();
  await db.initTable();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/welcome',
      routes: {
        '/mainPage': (context) => HappyMainPage(),
        '/welcome' : (context) => WelcomePage(),
        '/addPlate' : (context) => AddPlatePage(),
        '/addScore' : (context) => AddScorePage(),
      },
    );
  }
}


