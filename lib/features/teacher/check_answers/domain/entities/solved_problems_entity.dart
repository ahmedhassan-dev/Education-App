class SolvedProblemsEntity {
  final String id;
  final String uid;
  final List<String?> answer;
  final List<int> solvingTime;
  final String nextRepeat;
  final List<dynamic> solutionImgURL;

  SolvedProblemsEntity(this.id, this.uid, this.answer, this.solvingTime,
      this.nextRepeat, this.solutionImgURL);
}
