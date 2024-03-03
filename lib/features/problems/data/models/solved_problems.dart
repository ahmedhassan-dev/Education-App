import 'package:json_annotation/json_annotation.dart';
part 'solved_problems.g.dart';

@JsonSerializable()
class SolvedProblems {
  final String id;
  final String? answer;
  final int solvingTime;
  final String nextRepeat;
  final List<dynamic> topics;
  final List<dynamic> failureTime;
  final List<dynamic> needHelp;
  final List<dynamic> solvingDate;
  final List<dynamic> solutionImgURL;
  SolvedProblems({
    required this.id,
    this.answer,
    required this.solvingTime,
    required this.nextRepeat,
    required this.topics,
    required this.failureTime,
    required this.needHelp,
    required this.solvingDate,
    this.solutionImgURL = const [],
  });

  factory SolvedProblems.fromJson(Map<String, dynamic>? json) =>
      _$SolvedProblemsFromJson(json!);

  Map<String, dynamic> toJson() => _$SolvedProblemsToJson(this);
}
