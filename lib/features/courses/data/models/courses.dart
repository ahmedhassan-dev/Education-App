import 'package:education_app/features/courses/data/models/course_data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'courses.g.dart';

@JsonSerializable()
class Courses extends CourseData {
  final String imgUrl;
  final String subject;

  Courses(
      {required this.imgUrl,
      required this.subject,
      required super.author,
      required super.stage,
      required super.topics});

  factory Courses.fromJson(Map<String, dynamic>? json) =>
      _$CoursesFromJson(json!);

  Map<String, dynamic> toJson() => _$CoursesToJson(this);
}
