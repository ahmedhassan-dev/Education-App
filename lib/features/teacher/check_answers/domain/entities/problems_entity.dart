class ProblemsEntity {
  final String? problemId;
  final String courseID;
  final String problemTitle;
  final List<String> problemSolutions;
  final int problemScoreNum;

  ProblemsEntity(
      {required this.problemId,
      required this.courseID,
      required this.problemTitle,
      required this.problemSolutions,
      required this.problemScoreNum});
}
