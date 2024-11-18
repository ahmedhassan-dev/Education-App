import '../../../../problems/data/models/answer.dart';

class NeedReviewSolutionsEntity {
  final String solvedProblemid;
  final String studentID;
  final List<Answer?> studentAnswer;
  final List<int> studentSolvingTime;
  final String problemNextRepeat;

  NeedReviewSolutionsEntity(
      {required this.solvedProblemid,
      required this.studentID,
      required this.studentAnswer,
      required this.studentSolvingTime,
      required this.problemNextRepeat});
}
