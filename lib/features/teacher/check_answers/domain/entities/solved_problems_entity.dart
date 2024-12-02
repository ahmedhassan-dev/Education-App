import '../../../../problems/data/models/answer.dart';

class NeedReviewSolutionsEntity {
  final String solvedProblemid;
  final int problemId;
  final String studentID;
  final List<Answer> studentAnswer;
  final List<int> studentSolvingTime;
  final String problemNextRepeat;
  bool isNeedingReview;

  NeedReviewSolutionsEntity(
      {required this.solvedProblemid,
      required this.problemId,
      required this.studentID,
      required this.studentAnswer,
      required this.studentSolvingTime,
      required this.problemNextRepeat,
      required this.isNeedingReview});
}
