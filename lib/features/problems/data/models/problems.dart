import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'problems.g.dart';

@JsonSerializable()
class Problems extends ProblemsEntity {
  final String? id;
  final String authorEmail;
  final String authorName;
  final String stage;
  final String? courseId;
  final String title;
  final String problem;
  final String solution;
  final int scoreNum;
  final int time;
  final bool needReview;
  final List<dynamic> topics;
  final List<dynamic> videos;
  Problems({
    required this.id,
    required this.courseId,
    required this.title,
    required this.problem,
    required this.scoreNum,
    required this.solution,
    required this.stage,
    required this.authorEmail,
    required this.authorName,
    required this.time,
    required this.needReview,
    required this.topics,
    required this.videos,
  }) : super(
            problemId: id,
            problemTitle: title,
            problemSolutions: solution,
            problemScoreNum: scoreNum);

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
