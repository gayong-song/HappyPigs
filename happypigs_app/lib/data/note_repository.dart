import 'dart:developer' as developer;

import 'package:happypigs_app/db/Plate.dart';

class PlateRepository {
  static const TAG = 'PlateRepository';

  Future<List<Plate>> getNotes(int pageIndex) async {
    developer.log('getNotes [pageIndex] $pageIndex', name: TAG);
    List<Plate> datas = [];
    for (var i = 0; i < 20 ; i++) {
      datas.add(Plate(
          imgPaths: ["/home/1.jpg", "/home/2.jpg"],
          whereToEat: "Flora's home",
          whenToEat: DateTime.now(),
          description: "So delicious",
          tag_ids: [0, 1],
          rating: 3,
          plateTypeId: 0));
    }
    return Future.delayed(
        Duration(milliseconds: 500),
        () => datas
    );
  }

}