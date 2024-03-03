import 'package:education_app/features/authentication/data/models/user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'student.g.dart';

@JsonSerializable()
class Student extends User {
  final int totalScore;
  final Map<String, int> userScores;
  final Map<String, int> lastProblemIdx;
  final Map<String, String> lastProblemTime;

  Student(
      {required super.uid,
      required super.userName,
      required super.email,
      this.totalScore = 0,
      this.userScores = const {},
      this.lastProblemIdx = const {},
      this.lastProblemTime = const {}});

  factory Student.fromJson(Map<String, dynamic>? json) =>
      _$StudentFromJson(json!);

  Map<String, dynamic> toJson() => _$StudentToJson(this);
}
