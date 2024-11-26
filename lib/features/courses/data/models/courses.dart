import 'package:education_app/features/courses/data/models/course_data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'courses.g.dart';

@JsonSerializable()
class Courses extends CourseData {
  final String imgUrl;
  final String subject;
  final String description;
  int needReviewCounter;
  List<String> solutionsNeedingReview;

  Courses(
      {required super.id,
      required this.imgUrl,
      required this.subject,
      required this.description,
      this.needReviewCounter = 0,
      this.solutionsNeedingReview = const [],
      required super.authorEmail,
      required super.authorName,
      required super.stage,
      required super.topics});

  void decrementNeedReviewCounter() {
    needReviewCounter > 0 ? needReviewCounter-- : null;
  }

  void removeSolutionFromSolutionsNeedingReview(String id) {
    solutionsNeedingReview.remove(id);
  }

  List<int> getProblemIdsFromSolutionsNeedingReview() {
    return solutionsNeedingReview.map(
      (e) {
        int dashIndex = e.indexOf('-');
        if (dashIndex == -1) {
          return int.parse(e);
        }
        return int.parse(e.substring(0, dashIndex));
      },
    ).toList();
  }

  factory Courses.fromJson(Map<String, dynamic>? json) =>
      _$CoursesFromJson(json!);

  Map<String, dynamic> toJson() => _$CoursesToJson(this);
}
