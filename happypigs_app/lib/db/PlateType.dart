class PlateType {
  int plateTypeId;
  final String imgPath;
  final int plateGroupId;

  PlateType({this.plateTypeId, this.imgPath, this.plateGroupId});

  Map<String, dynamic> toMap() {
    return {
      'imgPath': imgPath,
      'plateGroupId': plateGroupId,
    };
  }

  @override
  String toString() {
    return 'PlateType{ '
        'plateTypeId: $plateTypeId, '
        'imgPath: $imgPath, '
        'plateGroupId: $plateGroupId}';
  }
}
