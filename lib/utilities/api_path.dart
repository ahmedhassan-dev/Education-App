class ApiPath {
  static String courses() => 'courses/';
  static String student(String uid) => 'students/$uid';
  static String teacher(String uid) => 'teachers/$uid';
  // static String problemsTeacherIdList() =>
  //     'problems/problemsTeacherIdList/teacherId';
  static String studentCollection() => 'students';
  static String teachersCollection() => 'teachers';
  static String userToken(String uid, String userType) =>
      '${"${userType.toLowerCase()}s"}/$uid/tokens/${DateTime.now()}';
  static String problems() => 'problems/';
  static String storingProblem(String problemId) => 'problems/$problemId';
  static String lastProblemId() => 'publicInfo/';
  static String solvedProblems(String uid, String solutionId) =>
      'students/$uid/solvedProblems/$solutionId';
  // static String solutions(String uid) => 'users/$uid/solvedProblems/';
}
