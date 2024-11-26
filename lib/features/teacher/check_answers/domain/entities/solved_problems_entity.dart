import '../../../../problems/data/models/answer.dart';

class NeedReviewSolutionsEntity {
  final String solvedProblemid;
  final String studentID;
  final List<Answer> studentAnswer;
  final List<int> studentSolvingTime;
  final String problemNextRepeat;
  bool isNeedingReview;

  NeedReviewSolutionsEntity(
      {required this.solvedProblemid,
      required this.studentID,
      required this.studentAnswer,
      required this.studentSolvingTime,
      required this.problemNextRepeat,
      required this.isNeedingReview});

  int getProblemId() {
    int dashIndex = solvedProblemid.indexOf('-');
    if (dashIndex == -1) {
      return int.parse(solvedProblemid);
    }
    return int.parse(solvedProblemid.substring(0, dashIndex));
  }
}
