class UserData {
  final String uid;
  final String? userName;
  final String? email;
  final int userScore;
  final Map<String, int> lastProblemIdx;
  final Map<String, String> lastProblemTime;

  UserData(
      {required this.uid,
      required this.userName,
      required this.email,
      this.userScore = 0,
      this.lastProblemIdx = const {},
      this.lastProblemTime = const {}});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'userName': userName});
    result.addAll({'email': email});
    result.addAll({'userScore': userScore});
    result.addAll({'lastProblemIdx': lastProblemIdx});
    result.addAll({'lastProblemTime': lastProblemTime});

    return result;
  }

  factory UserData.fromMap(Map<String, dynamic> map, String documentId) {
    return UserData(
      uid: documentId,
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      userScore: map['userScore'] ?? '',
      lastProblemIdx: map['lastProblemIdx'] ?? '',
      lastProblemTime: map['lastProblemTime'] ?? '',
    );
  }
}
