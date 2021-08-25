class Plate {
  int plateId;
  List<String> imgPaths = [];
  String foodImage;
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
      this.whereToEat,
      this.whenToEat,
      this.description,
      this.tag_ids,
      this.rating,
      this.plateTypeId});

  Map<String, dynamic> toMap() {
    return {
      'foodImage': foodImage,
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
//        'foodImage: $foodImage'
        'imgPaths: $imgPaths, '
        'whereToEat: $whereToEat, '
        'whenToEat: $whenToEat, '
        'description: $description, '
        'tags: $tag_ids, '
        'rating: $rating, '
        'plateTypeId: $plateTypeId';
  }
}
