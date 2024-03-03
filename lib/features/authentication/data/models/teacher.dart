import 'package:education_app/features/authentication/data/models/user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'teacher.g.dart';

@JsonSerializable()
class Teacher extends User {
  final String? phoneNum;
  final List<dynamic>? subjects;
  final List<dynamic>? educationalStages;
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

  factory Teacher.fromJson(Map<String, dynamic>? json) =>
      _$TeacherFromJson(json!);

  Map<String, dynamic> toJson() => _$TeacherToJson(this);

  Teacher copyWith({
    String? uid,
    String? userName,
    String? email,
    String? phoneNum,
    List<dynamic>? subjects,
    List<dynamic>? educationalStages,
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
