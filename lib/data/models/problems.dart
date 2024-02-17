import 'package:cloud_firestore/cloud_firestore.dart';

class Problems {
  final String? id;
  final String? problemId;
  final String title;
  final String problem;
  final String solution;
  final String stage;
  final String author;
  final int scoreNum;
  final int time;
  final bool needReview;
  final List<String> topics;
  final List<String> videos;
  Problems({
    required this.id,
    required this.problemId,
    required this.title,
    required this.problem,
    required this.scoreNum,
    required this.solution,
    required this.stage,
    required this.author,
    required this.time,
    required this.needReview,
    required this.topics,
    required this.videos,
  });
  Map<String, dynamic> toMap() {
    return {
      'problemId': problemId,
      'id': id,
      'title': title,
      'problem': problem,
      'solution': solution,
      'stage': stage,
      'author': author,
      'scoreNum': scoreNum,
      'time': time,
      'needReview': needReview,
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
      solution: map['solution'] as String,
      stage: map['stage'] as String,
      author: map['author'] as String,
      scoreNum: map['scoreNum'] as int,
      time: map['time'] as int,
      needReview: map['needReview'] as bool,
      topics: map['topics'] as List<String>,
      videos: map['videos'] as List<String>,
    );
  }

  Problems.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        problemId = doc.data()!["problemId"],
        title = doc.data()!["title"],
        problem = doc.data()!["problem"],
        solution = doc.data()!["solution"],
        stage = doc.data()!["stage"],
        author = doc.data()!["author"],
        scoreNum = doc.data()!["scoreNum"],
        time = doc.data()!["time"],
        needReview = doc.data()!["needReview"],
        topics = doc.data()!["topics"] == null
            ? null
            : doc.data()?["topics"].cast<String>(),
        videos = doc.data()!["videos"] == null
            ? null
            : doc.data()?["videos"].cast<String>();

  Problems copyWith({
    String? id,
    String? problemId,
    String? title,
    String? problem,
    String? solution,
    String? stage,
    String? author,
    int? scoreNum,
    int? time,
    bool? needReview,
    List<String>? topics,
    List<String>? videos,
  }) {
    return Problems(
      id: id ?? this.id,
      problemId: problemId ?? this.problemId,
      title: title ?? this.title,
      problem: problem ?? this.problem,
      solution: solution ?? this.solution,
      stage: stage ?? this.stage,
      author: author ?? this.author,
      scoreNum: scoreNum ?? this.scoreNum,
      time: time ?? this.time,
      needReview: needReview ?? this.needReview,
      topics: topics ?? this.topics,
      videos: videos ?? this.videos,
    );
  }
}
