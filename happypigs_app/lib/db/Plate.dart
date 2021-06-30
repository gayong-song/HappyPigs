import 'PlateType.dart';
import 'Tag.dart';

class Plate {
  final int plateId;
  List<String> imgPaths;
  final String whereToEat;
  final DateTime whenToEat;
  final String description;
  List<Tag> tags;
  final int rating;
  final int plateTypeId;

  Plate(
      {this.plateId,
      // this.imgPaths,
      this.whereToEat,
      this.whenToEat,
      this.description,
      // this.tags,
      this.rating,
      this.plateTypeId});

  Map<String, dynamic> toMap() {
    return {
      // 'imgPaths': imgPaths,
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
        'tags: $tags, '
        'rating: $rating, '
        'plateTypeId: $plateTypeId';
  }
}
