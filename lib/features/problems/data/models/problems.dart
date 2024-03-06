import 'package:education_app/features/courses/data/models/course_data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'problems.g.dart';

@JsonSerializable()
class Problems extends CourseData {
  final String? id;
  final String? problemId;
  final String title;
  final String problem;
  final String solution;
  final int scoreNum;
  final int time;
  final bool needReview;
  final List<dynamic> videos;
  Problems({
    required this.id,
    required this.problemId,
    required this.title,
    required this.problem,
    required this.scoreNum,
    required this.solution,
    required super.stage,
    required super.author,
    required this.time,
    required this.needReview,
    required super.topics,
    required this.videos,
  });

  factory Problems.fromJson(Map<String, dynamic>? json) =>
      _$ProblemsFromJson(json!);

  Map<String, dynamic> toJson() => _$ProblemsToJson(this);

  Problems copyWith({
    String? id,
    String? problemId,
    String? title,
    String? problem,
    String? solution,
    String? stage,
    Map<String, dynamic>? author,
    int? scoreNum,
    int? time,
    bool? needReview,
    List<dynamic>? topics,
    List<dynamic>? videos,
  }) {
    return Problems(
      id: id ?? this.id,
      problemId: problemId ?? this.problemId,
      title: title ?? this.title,
      problem: problem ?? this.problem,
      solution: solution ?? this.solution,
      stage: stage ?? this.stage,
      author: author ?? this.author,
      scoreNum: scoreNum ?? this.scoreNum,
      time: time ?? this.time,
      needReview: needReview ?? this.needReview,
      topics: topics ?? this.topics,
      videos: videos ?? this.videos,
    );
  }
}
