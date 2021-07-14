class Tag {
  int tagId;
  String name="";

  Tag({this.tagId, this.name});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Tag{tagId: $tagId, name: $name}';
  }
}
