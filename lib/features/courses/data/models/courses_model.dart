import 'package:cloud_firestore/cloud_firestore.dart';

class CoursesModel {
  final String imgUrl;
  final String subject;

  CoursesModel({
    required this.imgUrl,
    required this.subject,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'imgUrl': imgUrl});
    result.addAll({'subject': subject});

    return result;
  }

  factory CoursesModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CoursesModel(
      imgUrl: map['imgUrl'] ?? '',
      subject: map['subject'] ?? '',
    );
  }
  CoursesModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : imgUrl = doc.data()!["imgUrl"],
        subject = doc.data()!["subject"];
}
