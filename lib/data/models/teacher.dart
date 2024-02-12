import 'package:education_app/data/models/user.dart';

class Teacher extends User {
  final String? phoneNum;
  final List<String>? subjects;
  final List<String>? educationalStages;
  final Map<String, String> problemsAdded;

  Teacher({
    required super.uid,
    required super.userName,
    required super.email,
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

  factory Teacher.fromMap(Map<String, dynamic> map, String documentId) {
    return Teacher(
      uid: documentId,
      userName: map['userName'] ?? '',
      email: map['email'] ?? '',
      phoneNum: map['phoneNum'] ?? '',
      subjects: map['subjects'] ?? '',
      educationalStages: map['educationalStages'] ?? '',
      problemsAdded: map['problemsAdded'] ?? '',
    );
  }

  Teacher copyWith({
    String? uid,
    String? userName,
    String? email,
    String? phoneNum,
    List<String>? subjects,
    List<String>? educationalStages,
    Map<String, String>? problemsAdded,
  }) {
    return Teacher(
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
