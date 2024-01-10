class Problems {
  final String id;
  final String title;
  final String problem;
  final int scoreNum;
  final int time;
  final List<String> topics;
  final List<String> videos;
  Problems({
    required this.id,
    required this.title,
    required this.problem,
    required this.scoreNum,
    this.time = 0,
    required this.topics,
    required this.videos,
  });
  Map<String, dynamic> toMap() {
    return {
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
      title: map['title'] as String,
      problem: map['problem'] as String,
      scoreNum: map['scoreNum'] as int,
      time: map['time'] as int,
      topics: map['topics'] as List<String>,
      videos: map['videos'] as List<String>,
    );
  }
}
