import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:happypigs_app/util.dart';
import 'package:happypigs_app/db/Plate.dart';

class AddScorePage extends StatefulWidget {
  @override
  _AddScorePageState createState() => _AddScorePageState();
}

class _AddScorePageState extends State<AddScorePage> {
  @override
  Widget build(BuildContext context) {
    var contextSize = MediaQuery.of(context).size;
    final newPlate = ModalRoute.of(context).settings.arguments as Plate;
    print(newPlate);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.navigate_before),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            color: Colors.black,
            onPressed: () async {
              Navigator.of(context).pushNamed('/');
            },
          ),
        ],
        backgroundColor: Colors.grey,
      ),
      body: Center(
          child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: contextSize.height * 0.1,
              width: contextSize.width * 0.6,
              color: Colors.pink.shade50,
              child: Center(
                child: SmoothStarRating(
                    allowHalfRating: false,
                    onRated: (v) {
                      newPlate.rating = v.toInt();
                      print(v);
                    },
                    starCount: 3,
                    rating: (newPlate.rating<0? 0: newPlate.rating).toDouble(),
                    size: 40.0,
                    isReadOnly: false,
                    color: Colors.pink,
                    borderColor: Colors.pink,
                    spacing: 20.0),
              ),
            ),
            Container(
              height: contextSize.height * 0.1,
            ),
            Container(
              height: contextSize.height * 0.4,
              width: contextSize.height * 0.4,
              child: ClipOval(
                child: Utility.imageFromBase64String(newPlate.foodImage),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
