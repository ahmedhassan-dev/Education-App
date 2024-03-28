import 'package:education_app/features/courses/data/models/course_data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'courses.g.dart';

@JsonSerializable()
class Courses extends CourseData {
  final String imgUrl;
  final String subject;
  final String description;
  final int needReviewCounter;

  Courses(
      {required super.id,
      required this.imgUrl,
      required this.subject,
      required this.description,
      this.needReviewCounter = 0,
      required super.authorEmail,
      required super.authorName,
      required super.stage,
      required super.topics});

  factory Courses.fromJson(Map<String, dynamic>? json) =>
      _$CoursesFromJson(json!);

  Map<String, dynamic> toJson() => _$CoursesToJson(this);
}
