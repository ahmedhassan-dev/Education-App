class NeedReviewSolutionsEntity {
  final String solvedProblemid;
  final String studentID;
  final List<String?> studentAnswer;
  final List<int> studentSolvingTime;
  final String problemNextRepeat;
  final List<dynamic> answerImgURL;

  NeedReviewSolutionsEntity(
      {required this.solvedProblemid,
      required this.studentID,
      required this.studentAnswer,
      required this.studentSolvingTime,
      required this.problemNextRepeat,
      required this.answerImgURL});
}
