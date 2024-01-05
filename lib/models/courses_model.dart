class CoursesModel {
  final String imgUrl;

  CoursesModel({
    required this.imgUrl,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'imgUrl': imgUrl});

    return result;
  }

  factory CoursesModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CoursesModel(
      imgUrl: map['imgUrl'] ?? '',
    );
  }
}
