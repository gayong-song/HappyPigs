import 'package:flutter/material.dart';
import 'package:happypigs_app/db/db_manager.dart';
import 'package:happypigs_app/db/db_manager.dart';
import 'package:happypigs_app/db/PlateType.dart';
import 'package:happypigs_app/db/Plate.dart';
import 'package:happypigs_app/db/Tag.dart';
import 'package:happypigs_app/db/User.dart';

import 'db/db_manager.dart';

class HappyMainPage extends StatefulWidget {
  @override
  _HappyMainPageState createState() => _HappyMainPageState();

}

class _HappyMainPageState extends State<HappyMainPage> {
  DBHelper db_helper;

  @override
  void initState(){
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
    return Scaffold();
  }

  Future<void> create_samples_for_test() async {
    var plate_ex1 = Plate(
        // imgPaths: "",
        whereToEat: "Flora's home",
        whenToEat: DateTime.now(),
        description: "So delicious",
        // tags: [],
        rating: 3,
        plateTypeId: 0);
    print(plate_ex1);
    await db_helper.insertPlate(plate_ex1);

    var platetype_ex1 = PlateType(
        imgPath: "",
        plateGroupId: 0);
    print(platetype_ex1);
    await db_helper.insertPlateType(platetype_ex1);

    var tag_ex1 = Tag(
      name: "Italian"
    );
    print(tag_ex1);
    await db_helper.insertTag(tag_ex1);

    await db_helper.insertUser(User(name: 'piggy'));
    print("Succeed to insert----------");
  }
}
