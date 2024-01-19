class ApiPath {
  static String courses() => 'courses/';
  static String user(String uid) => 'users/$uid';
  static String problems() => 'problems/';
  static String solvedProblems(String uid, String solutionId) =>
      'users/$uid/solvedProblems/$solutionId';
  // static String solutions(String uid) => 'users/$uid/solvedProblems/';
}
