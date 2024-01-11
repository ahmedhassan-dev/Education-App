import 'package:cloud_firestore/cloud_firestore.dart';

class Problems {
  final String id;
  final String problemId;
  final String title;
  final String problem;
  final int scoreNum;
  final int time;
  final List<String> topics;
  final List<String> videos;
  Problems({
    required this.id,
    required this.problemId,
    required this.title,
    required this.problem,
    required this.scoreNum,
    this.time = 0,
    required this.topics,
    required this.videos,
  });
  Map<String, dynamic> toMap() {
    return {
      'problemId': problemId,
      'id': id,
      'title': title,
      'problem': problem,
      'scoreNum': scoreNum,
      'time': time,
      'topics': topics,
      'videos': videos,
    };
  }

  factory Problems.fromMap(Map<String, dynamic> map, String documentId) {
    return Problems(
      id: documentId,
      problemId: map['problemId'] as String,
      title: map['title'] as String,
      problem: map['problem'] as String,
      scoreNum: map['scoreNum'] as int,
      time: map['time'] as int,
      topics: map['topics'] as List<String>,
      videos: map['videos'] as List<String>,
    );
  }

  Problems.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        problemId = doc.data()!["problemId"],
        title = doc.data()!["title"],
        problem = doc.data()!["problem"],
        scoreNum = doc.data()!["scoreNum"],
        time = doc.data()!["time"],
        topics = doc.data()?["topics"] == null
            ? null
            : doc.data()?["topics"].cast<String>(),
        videos = doc.data()?["videos"] == null
            ? null
            : doc.data()?["videos"].cast<String>();
}
