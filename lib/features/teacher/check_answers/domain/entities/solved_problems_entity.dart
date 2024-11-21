import '../../../../problems/data/models/answer.dart';

class NeedReviewSolutionsEntity {
  final String solvedProblemid;
  final String studentID;
  final List<Answer> studentAnswer;
  final List<int> studentSolvingTime;
  final String problemNextRepeat;

  NeedReviewSolutionsEntity(
      {required this.solvedProblemid,
      required this.studentID,
      required this.studentAnswer,
      required this.studentSolvingTime,
      required this.problemNextRepeat});

  String getProblemId() {
    int dashIndex = solvedProblemid.indexOf('-');
    if (dashIndex == -1) {
      return solvedProblemid;
    }
    return solvedProblemid.substring(0, dashIndex);
  }
}
