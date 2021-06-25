
import 'PlateType.dart';
import 'Tag.dart';

class Plate {
  final int plateId;
  final List<String> imgPaths;
  final String whereToEat;
  final DateTime whenToEat;
  final String description;
  final List<Tag> tags;
  final int rating;
  final PlateType plateType;

  Plate(this.plateId, this.imgPaths, this.whereToEat, this.whenToEat,
      this.description, this.tags, this.rating, this.plateType);
}