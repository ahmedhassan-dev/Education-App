class TeacherData {
  final String uid;
  final String? userName;
  final String? email;
  final String? phoneNum;
  final List<String>? subjects;
  final List<String>? educationalStages;
  final Map<String, String> problemsAdded;

  TeacherData({
    required this.uid,
    required this.userName,
    required this.email,
    this.phoneNum,
    this.subjects = const [],
    this.educationalStages = const [],
    this.problemsAdded = const {},
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'userName': userName});
    result.addAll({'email': email});
    result.addAll({'phoneNum': phoneNum});
    result.addAll({'subjects': subjects});
    result.addAll({'educationalStages': educationalStages});
    result.addAll({'problemsAdded': problemsAdded});

    return result;
  }

  factory TeacherData.fromMap(Map<String, dynamic> map, String documentId) {
    return TeacherData(
      uid: documentId,
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      phoneNum: map['phoneNum'] ?? '',
      subjects: map['subjects'] ?? '',
      educationalStages: map['educationalStages'] ?? '',
      problemsAdded: map['problemsAdded'] ?? '',
    );
  }

  TeacherData copyWith({
    String? uid,
    String? userName,
    String? email,
    String? phoneNum,
    List<String>? subjects,
    List<String>? educationalStages,
    Map<String, String>? problemsAdded,
  }) {
    return TeacherData(
      uid: uid ?? this.uid,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phoneNum: phoneNum ?? this.phoneNum,
      subjects: subjects ?? this.subjects,
      educationalStages: educationalStages ?? this.educationalStages,
      problemsAdded: problemsAdded ?? this.problemsAdded,
    );
  }
}
