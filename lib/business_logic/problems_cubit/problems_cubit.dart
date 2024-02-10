import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:education_app/data/models/problems.dart';
import 'package:education_app/data/models/solved_problems.dart';
import 'package:education_app/data/repository/problems_repo.dart';
import 'package:education_app/utilities/api_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
part 'problems_state.dart';

class ProblemsCubit extends Cubit<ProblemsState> {
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime now = DateTime.now();
  String subject = "";
  int score = 0;
  Map<String, dynamic> userScores = {};
  Map<String, dynamic> lastProblemIdx = {};
  Map<String, dynamic> lastProblemTime = {};
  int problemIndex = 0;
  List<Problems>? retrievedProblemList;
  DateTime startCounting = DateTime.now();
  List<String> solvedProblemsList = [];
  dynamic userData = {};
  List<Problems> problems = [];
  ProblemsRepository problemsRepository;
  List<SolvedProblems>? retrievedSolutionList;
  ProblemsCubit(this.problemsRepository) : super(ProblemsInitial());
  String uid = FirebaseAuth.instance.currentUser!.uid;
  SolvedProblems? solvedProblems;
  bool solvedBefore = false;
  Queue<int> prbolemIndexQueue = Queue<int>();
  List<String> failureTime = [];
  List<String> solvingDate = [];
  List<String> needHelpTime = [];
  bool needHelp = false;
  String nextRepeat = DateTime.now().add(const Duration(days: 30)).toString();

  retrieveUserData({required String subject}) async {
    this.subject = subject;
    await problemsRepository
        .retrieveUserData(path: ApiPath.userCollection(), docName: uid)
        .then((userData) {
      this.userData = userData.data()!;
    });
    initUserData();
  }

  initUserData() {
    score = userData["totalScore"];
    userScores = userData["userScores"];
    lastProblemIdx =
        userData["lastProblemIdx"]; //Adding the firebase map to the local map
    lastProblemTime =
        userData["lastProblemTime"]; //Adding the firebase map to the local map
    if (userData["userScores"][subject] == null) {
      userScores[subject] = 0;
    }
    if (userData["lastProblemIdx"][subject] == null) {
      lastProblemIdx[subject] = 0; // Adding new subject to the map
      lastProblemTime[subject] = "0"; // Adding new subject to the map
    } else {
      problemIndex = userData["lastProblemIdx"][subject];
    }
  }

  updatingUserData() async {
    if (!solvedBefore) {
      score += retrievedProblemList![problemIndex].scoreNum;
      userScores[subject] =
          userScores[subject] + retrievedProblemList![problemIndex].scoreNum;
      lastProblemIdx[subject] = problemIndex + 1;
      lastProblemTime[subject] = DateTime.now().toString();
      problemsRepository.updateUserData(
          path: ApiPath.user(uid),
          score: score,
          userScores: userScores,
          lastProblemIdx: lastProblemIdx,
          lastProblemTime: lastProblemTime);
    }
  }

  retrieveSubjectProblems() async {
    await problemsRepository
        .retrieveSubjectProblems(
            subject: subject, path: ApiPath.problems(), sortedBy: 'problemId')
        .then((retrievedProblemList) {
      this.retrievedProblemList = retrievedProblemList;
    });

    await initRetrievalSolutions();
    startCounting = DateTime.now();
  }

  checkProblemsAvailability() =>
      !(retrievedProblemList!.length == problemIndex);

  initRetrievalSolutions() async {
    await problemsRepository
        .retrieveSolvedProblems(
            subject: subject,
            mainCollectionPath: ApiPath.userCollection(),
            uid: uid,
            collectionPath: 'solvedProblems',
            sortedBy: 'id')
        .then((retrievedSolutionList) {
      this.retrievedSolutionList = retrievedSolutionList;
    });
    //TODO: Need to refactor this
    for (var element in retrievedSolutionList!) {
      solvedProblemsList.add(element.id);
    }
    nextRepeatProblemsIndex();
    solvedBeforeFun();
    addOldSolution2New();
    emit(DataLoaded(retrievedProblemList, userData, retrievedSolutionList));
  }

  nextRepeatProblemsIndex() {
    DateTime timeNow = DateTime.now();
    // TODO: need to sort elements nextRepeat and use binary search
    for (var element in retrievedSolutionList!) {
      if ((DateTime.parse(element.nextRepeat).difference(timeNow).inDays < 0 ||
              DateTime.parse(element.nextRepeat).day == timeNow.day) &&
          timeNow
                  .difference(DateTime.parse(element.solvingDate.last))
                  .inHours >=
              12) {
        prbolemIndexQueue.add(retrievedSolutionList!.indexOf(element));
      }
    }
    showRepeatedProblems();
  }

  bool waitForSolving = false;
  // After submission or after solving new problem today
  showRepeatedProblems() {
    if (waitForSolving) {
      prbolemIndexQueue.removeFirst();
      waitForSolving = false;
    }
    if (prbolemIndexQueue.isNotEmpty &&
        (formatter.format(DateTime.parse(lastProblemTime[subject])) ==
                formatter.format(now) ||
            retrievedProblemList!.length == problemIndex)) {
      problemIndex = prbolemIndexQueue.first;
      waitForSolving = true;
    } else if (prbolemIndexQueue.isEmpty) {
      problemIndex = userData["lastProblemIdx"][subject];
    }
  }

  solvedBeforeFun() {
    problemIndex < retrievedProblemList!.length
        ? solvedBefore = solvedProblemsList
            .contains(retrievedProblemList![problemIndex].problemId)
        : solvedBefore = false;
  }

  // TODO: Make copywith method in model
  addOldSolution2New() {
    if (solvedBefore) {
      failureTime.addAll(retrievedSolutionList![problemIndex].failureTime);
      solvingDate.addAll(retrievedSolutionList![problemIndex].solvingDate);
      needHelpTime.addAll(retrievedSolutionList![problemIndex].needHelp);
    }
  }

  nextRepeatFun() {
    if (needHelp) {
      nextRepeat = DateTime.now().add(const Duration(days: 1)).toString();
    } else if (DateTime.now().difference(startCounting).inSeconds >
        retrievedProblemList![problemIndex].time * 60) {
      nextRepeat = DateTime.now().add(const Duration(days: 2)).toString();
    } else if (failureTime.isNotEmpty) {
      if (DateTime.parse(failureTime.last).day == DateTime.now().day) {
        nextRepeat = DateTime.now().add(const Duration(days: 3)).toString();
      }
    } else {
      nextRepeat = DateTime.now().add(const Duration(days: 30)).toString();
    }
  }

  resetVariables() {
    problemIndex += 1;
    needHelp = false;
    startCounting = DateTime.now();
    failureTime = [];
    solvingDate = [];
    needHelpTime = [];
  }

  showNeedHelpList() {
    needHelp = true;
    needHelpTime.add(DateTime.now().toString());
  }

  recordFailureTime() {
    failureTime.add(DateTime.now().toString());
  }

  Future<void> submitSolution(String solutionController) async {
    updatingUserData();
    solvingDate.add(DateTime.now().toString());
    nextRepeatFun();

    final solutionData = SolvedProblems(
      id: solvedProblems != null
          ? solvedProblems!.id
          : retrievedProblemList![problemIndex].problemId,
      answer: solutionController,
      solvingTime: DateTime.now().difference(startCounting).inSeconds,
      nextRepeat: nextRepeat,
      topics: retrievedProblemList![problemIndex].topics,
      failureTime: failureTime,
      needHelp: needHelpTime,
      solvingDate: solvingDate,
    );
    emit(Loading());
    await problemsRepository.submitSolution(
      solution: solutionData,
      path: ApiPath.solvedProblems(
        uid,
        retrievedProblemList![problemIndex].problemId,
      ),
    );
    resetVariables();
    showRepeatedProblems();
    solvedBeforeFun();
    addOldSolution2New();
    emit(DataLoaded(retrievedProblemList, userData, retrievedSolutionList));
  }

  String get problemId => retrievedProblemList![problemIndex].problemId;
  String get title => retrievedProblemList![problemIndex].title;
  List<String> get topics => retrievedProblemList![problemIndex].topics;
  int get expectedTime => retrievedProblemList![problemIndex].time;
  String get problem => retrievedProblemList![problemIndex].problem;
  String get solution => retrievedProblemList![problemIndex].solution;
  bool get needReview => retrievedProblemList![problemIndex].needReview;
  List<String> get videos => retrievedProblemList![problemIndex].videos;
  String get userScore => score.toString();
}
