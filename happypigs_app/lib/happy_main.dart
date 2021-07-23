import 'package:flutter/material.dart';
import 'package:happypigs_app/db/Plate.dart';
import 'package:happypigs_app/db/PlateType.dart';
import 'package:happypigs_app/db/Tag.dart';
import 'package:happypigs_app/db/User.dart';
import 'package:happypigs_app/db/db_manager.dart';

import 'db/db_manager.dart';

class HappyMainPage extends StatefulWidget {
  @override
  _HappyMainPageState createState() => _HappyMainPageState();
}

class _HappyMainPageState extends State<HappyMainPage> {
  DBHelper db_helper;

  @override
  void initState() {
    super.initState();
    db_helper = DBHelper();
  }

  Future<void> test() async {
    print("------ Test to insert ----- ");
    await create_samples_for_test();
    print("------ Read User -------");
    print(await db_helper.readUser());
    print("------ Read Tag -------");
    print(await db_helper.readTags());
    print("------ Read PlateType -------");
    print(await db_helper.readPlateTypes());
    print("------ Read Plate -------");
    print(await db_helper.readPlates());
  }

  @override
  Widget build(BuildContext context) {
    test();
    return Scaffold(
      appBar: AppBar(
        title: Text('Happy Pig Main Page'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/addPlate');
        },
        child: Icon(Icons.add_circle),
      ),
    );
  }

  Future<void> create_samples_for_test() async {
    var plate_ex1 = Plate(
        imgPaths: ["/home/1.jpg", "/home/2.jpg"],
        whereToEat: "Flora's home",
        whenToEat: DateTime.now(),
        description: "So delicious",
        tag_ids: [0, 1],
        rating: 3,
        plateTypeId: 0);
    print("Try to insert $plate_ex1");
    await db_helper.insertPlate(plate_ex1);

    var plate_ex2 = Plate(
        imgPaths: ["/home/3.jpg", "/home/4.jpg"],
        whereToEat: "Future's home",
        whenToEat: DateTime.now(),
        description: "So nice",
        tag_ids: [2],
        rating: 2,
        plateTypeId: 0);
    print("Try to insert $plate_ex2");
    await db_helper.insertPlate(plate_ex2);

    var plate_ex3 = Plate(
        imgPaths: ["/home/1.jpg"],
        whereToEat: "Yuni's home",
        whenToEat: DateTime.now(),
        description: "Awesome",
        tag_ids: [],
        rating: 1,
        plateTypeId: 0);
    print("Try to insert $plate_ex3");
    await db_helper.insertPlate(plate_ex3);

    var platetype_ex1 = PlateType(imgPath: "", plateGroupId: 0);
    print(platetype_ex1);
    await db_helper.insertPlateType(platetype_ex1);

    var tag_ex1 = Tag(name: "Italian");
    print(tag_ex1);
    await db_helper.insertTag(tag_ex1);

    await db_helper.insertUser(User(name: 'piggy'));
    print("Succeed to insert----------");
  }
}
