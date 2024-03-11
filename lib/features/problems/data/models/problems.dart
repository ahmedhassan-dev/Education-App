import 'package:education_app/features/courses/data/models/course_data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'problems.g.dart';

@JsonSerializable()
class Problems extends CourseData {
  final String? courseId;
  final String title;
  final String problem;
  final String solution;
  final int scoreNum;
  final int time;
  final bool needReview;
  final List<dynamic> videos;
  Problems({
    required super.id,
    required this.courseId,
    required this.title,
    required this.problem,
    required this.scoreNum,
    required this.solution,
    required super.stage,
    required super.authorEmail,
    required super.authorName,
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
    String? courseId,
    String? title,
    String? problem,
    String? solution,
    String? stage,
    String? authorEmail,
    String? authorName,
    int? scoreNum,
    int? time,
    bool? needReview,
    List<dynamic>? topics,
    List<dynamic>? videos,
  }) {
    return Problems(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      problem: problem ?? this.problem,
      solution: solution ?? this.solution,
      stage: stage ?? this.stage,
      authorEmail: authorEmail ?? this.authorEmail,
      authorName: authorName ?? this.authorName,
      scoreNum: scoreNum ?? this.scoreNum,
      time: time ?? this.time,
      needReview: needReview ?? this.needReview,
      topics: topics ?? this.topics,
      videos: videos ?? this.videos,
    );
  }
}
