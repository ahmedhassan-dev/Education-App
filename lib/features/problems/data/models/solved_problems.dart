import 'package:json_annotation/json_annotation.dart';
part 'solved_problems.g.dart';

@JsonSerializable()
class SolvedProblems {
  final String id;
  final String uid;
  final String? courseId;
  final List<String?> answer;
  final List<int> solvingTime;
  final String nextRepeat;
  final List<dynamic> topics;
  final List<dynamic> failureTime;
  final List<dynamic> needHelp;
  final List<dynamic> solvingDate;
  final List<dynamic> solutionImgURL;
  SolvedProblems({
    required this.id,
    required this.uid,
    required this.courseId,
    this.answer = const [],
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

  SolvedProblems copyWith({
    String? id,
    String? uid,
    String? courseId,
    List<String?>? answer,
    List<int>? solvingTime,
    String? nextRepeat,
    List<dynamic>? topics,
    List<dynamic>? failureTime,
    List<dynamic>? needHelp,
    List<dynamic>? solvingDate,
    List<dynamic>? solutionImgURL,
  }) {
    return SolvedProblems(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      courseId: courseId ?? this.courseId,
      answer: answer ?? this.answer,
      solvingTime: solvingTime ?? this.solvingTime,
      nextRepeat: nextRepeat ?? this.nextRepeat,
      topics: topics ?? this.topics,
      failureTime: failureTime ?? this.failureTime,
      needHelp: needHelp ?? this.needHelp,
      solvingDate: solvingDate ?? this.solvingDate,
      solutionImgURL: solutionImgURL ?? this.solutionImgURL,
    );
  }
}
