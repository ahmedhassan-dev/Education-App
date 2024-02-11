class Student {
  final String uid;
  final String? userName;
  final String? email;
  final int totalScore;
  final Map<String, int> userScores;
  final Map<String, int> lastProblemIdx;
  final Map<String, String> lastProblemTime;

  Student(
      {required this.uid,
      required this.userName,
      required this.email,
      this.totalScore = 0,
      this.userScores = const {},
      this.lastProblemIdx = const {},
      this.lastProblemTime = const {}});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'userName': userName});
    result.addAll({'email': email});
    result.addAll({'totalScore': totalScore});
    result.addAll({'userScores': userScores});
    result.addAll({'lastProblemIdx': lastProblemIdx});
    result.addAll({'lastProblemTime': lastProblemTime});

    return result;
  }

  factory Student.fromMap(Map<String, dynamic> map, String documentId) {
    return Student(
      uid: documentId,
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      totalScore: map['totalScore'] ?? '',
      userScores: map['userScores'] ?? '',
      lastProblemIdx: map['lastProblemIdx'] ?? '',
      lastProblemTime: map['lastProblemTime'] ?? '',
    );
  }
}
