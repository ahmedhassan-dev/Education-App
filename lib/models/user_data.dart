class UserData {
  final String uid;
  final String email;
  final int userScore;
  final Map<String, DateTime> lastProblem;

  UserData({
    required this.uid,
    required this.email,
    this.userScore = 0,
    required this.lastProblem,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'email': email});
    result.addAll({'userScore': userScore});
    result.addAll({'lastProblem': lastProblem});

    return result;
  }

  factory UserData.fromMap(Map<String, dynamic> map, String documentId) {
    return UserData(
      uid: documentId,
      email: map['email'] ?? '',
      userScore: map['userScore'] ?? '',
      lastProblem: map['lastProblem'] ?? '',
    );
  }
}
