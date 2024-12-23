import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Courses course = Courses(
      id: "1",
      problemsCount: 0,
      imgUrl: "imgUrl",
      subject: "subject",
      description: "description",
      authorEmail: "authorEmail",
      authorName: "authorName",
      stage: "stage",
      topics: [],
      solutionsNeedingReview: ["9-ahmed@stu5.co", "9-ahmed@stu7.co"]);
  test("getProblemIdsFromSolutionsNeedingReview method test", () {
    List<int> problemsNeedingReview =
        course.getProblemIdsFromSolutionsNeedingReview();
    expect(problemsNeedingReview, ["9", "9"]);
  });
}
