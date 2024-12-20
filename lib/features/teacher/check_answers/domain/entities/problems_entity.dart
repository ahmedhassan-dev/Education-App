class ProblemsEntity {
  final int globalProblemId;
  final int? problemId;
  final String courseID;
  final String title;
  final List<String> solutions;
  final int scoreNum;

  ProblemsEntity(
      {required this.globalProblemId,
      required this.problemId,
      required this.courseID,
      required this.title,
      required this.solutions,
      required this.scoreNum});
}
