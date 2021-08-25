import 'package:flutter/material.dart';
import 'package:happypigs_app/db/Plate.dart';
import 'package:happypigs_app/db/PlateType.dart';
import 'package:happypigs_app/db/Tag.dart';
import 'package:happypigs_app/db/User.dart';
import 'package:happypigs_app/db/db_manager.dart';
import 'package:happypigs_app/note_pages/grid_view_page.dart';
import 'package:happypigs_app/util.dart';

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
//    test();
  }

  Future<void> test() async {
    logger.d("------ Test to insert ----- ");
    await create_samples_for_test();
    logger.d("------ Read User -------");
    logger.d(await db_helper.readUser());
    logger.d("------ Read Tag -------");
    logger.d(await db_helper.readTags());
    logger.d("------ Read PlateType -------");
    logger.d(await db_helper.readPlateTypes());
    logger.d("------ Read Plate -------");
    logger.d(await db_helper.readPlates());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.1,
        title: Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    Navigator.of(context).pushNamed('/setting');
                  },
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.settings),
                ),
              ),
              Column(
                children: [
                  Text('Piggy!',
                      style: TextStyle(
                        fontFamily: 'Oi',
                        // fontWeight: FontWeight.w800,
                        color: Colors.pink,
                        fontSize: 34.0,
                      )),
                  Text('What did you eat?',
                      style: TextStyle(
                        fontFamily: 'Oi',
                        // fontWeight: FontWeight.w800,
                        color: Colors.black,
                        fontSize: 28.0,
                      )),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: Colors.grey,
      ),
      body: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: GridViewPage()),
      // floatingActionButtonLocation: FloatingActionButtonLocation,
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
    logger.d("Try to insert $plate_ex1");
    await db_helper.insertPlate(plate_ex1);

    var plate_ex2 = Plate(
        imgPaths: ["/home/3.jpg", "/home/4.jpg"],
        whereToEat: "Future's home",
        whenToEat: DateTime.now(),
        description: "So nice",
        tag_ids: [2],
        rating: 2,
        plateTypeId: 0);
    logger.d("Try to insert $plate_ex2");
    await db_helper.insertPlate(plate_ex2);

    var plate_ex3 = Plate(
        imgPaths: ["/home/1.jpg"],
        whereToEat: "Yuni's home",
        whenToEat: DateTime.now(),
        description: "Awesome",
        tag_ids: [],
        rating: 1,
        plateTypeId: 0);
    logger.d("Try to insert $plate_ex3");
    await db_helper.insertPlate(plate_ex3);

    var platetype_ex1 = PlateType(imgPath: "", plateGroupId: 0);
    logger.d(platetype_ex1);
    await db_helper.insertPlateType(platetype_ex1);

    var tag_ex1 = Tag(name: "Italian");
    logger.d(tag_ex1);
    await db_helper.insertTag(tag_ex1);

    await db_helper.insertUser(User(name: 'piggy'));
    logger.d("Succeed to insert----------");
  }
}
