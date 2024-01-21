class CatModel {
  final String id;
  final int width;
  final int height;
  final String image;

  CatModel({
    required this.id,
    required this.width,
    required this.height,
    required this.image,
  });

  factory CatModel.fromMap(Map<String, dynamic> map) {
    return CatModel(
        id: map['id'],
        width: map['width'],
        height: map['height'],
        image: map['url'],
        );
  }
}
