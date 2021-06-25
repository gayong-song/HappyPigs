

import 'package:flutter/material.dart';

import 'db/db_manager.dart';

class HappyMainPage extends StatefulWidget {
  @override
  _HappyMainPageState createState() => _HappyMainPageState();
}

class _HappyMainPageState extends State<HappyMainPage> {
  @override
  Widget build(BuildContext context) {
    load_Db();
    return Scaffold(
    );
  }

  Future<void> load_Db() async{
    await init_db();
    await printDatabase();
  }
}
