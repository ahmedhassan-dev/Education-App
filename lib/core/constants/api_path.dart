class ApiPath {
  static String courses() => 'courses/';
  static String coursesID(String courseID) => 'courses/$courseID';
  static String student(String uid) => 'students/$uid';
  static String teacher(String uid) => 'teachers/$uid';

  static String solvedProblemsCollection(String uid) =>
      'students/$uid/solvedProblems';
  static String studentCollection() => 'students';
  static String teachersCollection() => 'teachers';
  static String userToken(String uid, String userType) =>
      '${"${userType.toLowerCase()}s"}/$uid/tokens/${DateTime.now()}';
  static String problems() => 'problems/';
  static String storingProblem(String problemId) => 'problems/$problemId';
  static String publicInfo() => 'publicInfo/';
  static String problemsCount() => 'publicInfo/problemsCount/';
  static String solvedProblems(String uid, String solutionId) =>
      'students/$uid/solvedProblems/$solutionId';
}
