import 'package:photo_view/photo_view.dart';

class Plate {
  int plateId;
  List<String> imgPaths = [];
  String foodImage;
  PhotoViewControllerValue foodSetting;
  final String whereToEat;
  final DateTime whenToEat;
  final String description;
  List<int> tag_ids = [];
  int rating;
  final int plateTypeId;

  Plate(
      {this.plateId,
      this.imgPaths,
      this.foodImage,
      this.foodSetting,
      this.whereToEat,
      this.whenToEat,
      this.description,
      this.tag_ids,
      this.rating,
      this.plateTypeId});

  Map<String, dynamic> toMap() {
    return {
      'whereToEat': whereToEat,
      'whenToEat': whenToEat.toString(),
      'description': description,
      'rating': rating,
      'plateTypeId': plateTypeId,
    };
  }

  @override
  String toString() {
    return 'Plate(plateId: $plateId, '
        'imgPaths: $imgPaths, '
        'whereToEat: $whereToEat, '
        'whenToEat: $whenToEat, '
        'description: $description, '
        'tags: $tag_ids, '
        'rating: $rating, '
        'plateTypeId: $plateTypeId';
  }
}
