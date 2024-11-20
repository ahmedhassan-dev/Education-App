import 'dart:collection';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:education_app/features/authentication/data/models/student.dart';
import 'package:education_app/features/problems/data/models/answer.dart';
import 'package:education_app/features/problems/data/models/problems.dart';
import 'package:education_app/features/problems/data/models/solved_problems.dart';
import 'package:education_app/features/problems/data/repos/problems_repo.dart';
import 'package:education_app/core/constants/api_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:education_app/core/constants/constants.dart';
part 'problems_state.dart';

class ProblemsCubit extends Cubit<ProblemsState> {
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime now = DateTime.now();
  String subject = "";
  int score = 0;
  Map<String, dynamic> userScores = {};
  Map<String, Map<String, int>> lastProblemIdx = {};
  Map<String, dynamic> lastProblemTime = {};
  int problemIndex = 0;
  List<Problems>? problemList;
  DateTime startCounting = DateTime.now();
  List<String> solvedProblemsList = [];
  late Student student;
  List<Problems> problems = [];
  ProblemsRepository problemsRepository;
  List<SolvedProblems>? solutionList;
  ProblemsCubit(this.problemsRepository) : super(ProblemsInitial());
  String uid = FirebaseAuth.instance.currentUser!.uid;
  late String courseId;
  SolvedProblems? solvedProblems;
  Queue<int> prbolemIndexQueue = Queue<int>();
  bool needHelp = false;
  late Uint8List imgPath;
  late String imgName;

  retrieveStudentData(
      {required String subject, required String courseId}) async {
    this.subject = subject;
    this.courseId = courseId;
    await problemsRepository.retrieveStudentData(docName: uid).then((student) {
      this.student = student;
    });
    initStudentData();
  }

  void initStudentData() {
    score = student.totalScore;
    userScores = student.userScores;
    lastProblemIdx =
        student.lastProblemIdx; //Adding the firebase map to the local map
    lastProblemTime =
        student.lastProblemTime; //Adding the firebase map to the local map
    if (student.userScores[subject] == null) {
      userScores[subject] = 0;
    }

    if (student.lastProblemIdx[subject] == null) {
      lastProblemIdx[subject] =
          {courseId: 0}.cast<String, int>(); // Adding new subject to the map
      lastProblemTime[subject] = {courseId: "0"}
          .cast<String, String>(); // Adding new subject to the map
    } else if (student.lastProblemIdx[subject]![courseId] == null) {
      lastProblemIdx[subject]!.addEntries(<String, int>{courseId: 0}.entries);
      lastProblemTime[subject]!
          .addEntries(<String, String>{courseId: "0"}.entries);
    }
    problemIndex = student.lastProblemIdx[subject]?[courseId] ?? 0;
  }

  Future<void> _updatingStudentData() async {
    if (!solvedBefore()) {
      score += problemList![problemIndex].scoreNum;
      userScores[subject] =
          userScores[subject] + problemList![problemIndex].scoreNum;
      lastProblemIdx[subject]?[courseId] = problemIndex + 1;
      lastProblemTime[subject]?[courseId] = DateTime.now().toString();
      Map<String, dynamic> data = {
        "totalScore": score,
        "userScores": userScores,
        "lastProblemIdx": lastProblemIdx,
        "lastProblemTime": lastProblemTime
      };
      await problemsRepository.updatingStudentData(
          path: ApiPath.student(uid), data: data);
    }
  }

  Future<void> _incrementNeedReviewCounter(String? solutionController) async {
    if (_needTeacherReview(solutionController)) {
      await problemsRepository.incrementNeedReviewCounter(courseId: courseId);
    }
  }

  Future<void> _addProblemId2SolutionsNeedingReview() async {
    if (needReview) {
      await problemsRepository.addProblemId2SolutionsNeedingReview(
          courseId: courseId, solvedProblemId: solvedProblem.id);
    }
  }

  bool _needTeacherReview(String? solutionController) =>
      needReview &&
      !problemList![problemIndex].solutions.contains(solutionController);

  Future<void> retrieveCourseProblems({bool forTeachers = false}) async {
    await problemsRepository
        .retrieveCourseProblems(
            path: ApiPath.problems(), courseId: courseId, sortedBy: 'id')
        .then((problemList) {
      this.problemList = problemList;
    });

    if (!forTeachers) {
      await initRetrievalSolutions();
      startCounting = DateTime.now();
    } else {
      emit(ProblemsLoaded());
    }
  }

  bool checkProblemsAvailability() => problemList!.length > problemIndex;

  initRetrievalSolutions() async {
    await problemsRepository
        .retrieveSolvedProblems(uid: uid, courseId: courseId)
        .then((solutionList) {
      this.solutionList = solutionList;
    });
    //TODO: Need to refactor this
    for (var solvedProblem in solutionList!) {
      solvedProblemsList.add(solvedProblem.id);
    }
    nextRepeatProblemsIndex();
    _createSolvedProblemInstance();
    emit(DataLoaded(problemList, student, solutionList));
  }

  void nextRepeatProblemsIndex() {
    DateTime timeNow = DateTime.now();
    // TODO: need to sort elements nextRepeat and use binary search
    for (var element in solutionList!) {
      if (_isTodayOrBeforeTodayProblem(element, timeNow) &&
          _isProblemSolvedAfter12Hours(timeNow, element)) {
        prbolemIndexQueue.add(solutionList!.indexOf(element));
      }
    }
    _showRepeatedProblems();
  }

  bool _isProblemSolvedAfter12Hours(DateTime timeNow, SolvedProblems element) {
    return timeNow
            .difference(DateTime.parse(element.solvingDate.last))
            .inHours >=
        12;
  }

  bool _isTodayOrBeforeTodayProblem(SolvedProblems element, DateTime timeNow) {
    return (DateTime.parse(element.nextRepeat).difference(timeNow).inDays < 0 ||
        DateTime.parse(element.nextRepeat).day == timeNow.day);
  }

  bool waitForSolving = false;
  // After submission or after solving new problem today
  void _showRepeatedProblems() {
    if (waitForSolving) {
      prbolemIndexQueue.removeFirst();
      waitForSolving = false;
    }
    if (prbolemIndexQueue.isNotEmpty &&
        (isStudentSolvedAnyNewProblemToday() || !checkProblemsAvailability())) {
      problemIndex = prbolemIndexQueue.first;
      waitForSolving = true;
    } else if (prbolemIndexQueue.isEmpty) {
      problemIndex = lastProblemIdx[subject]![courseId]!;
    } else {
      problemIndex += 1;
    }
  }

  bool isStudentSolvedAnyNewProblemToday() {
    return formatter
            .format(DateTime.parse(lastProblemTime[subject]![courseId]!)) ==
        formatter.format(now);
  }

  bool solvedBefore() {
    return problemIndex < problemList!.length
        ? solvedProblemsList
            .contains("${problemList![problemIndex].id}-${student.email}")
        : false;
  }

  late SolvedProblems solvedProblem;
  void _createSolvedProblemInstance() {
    if (solvedBefore()) {
      solvedProblem = solutionList![problemIndex];
    } else if (problemList!.isNotEmpty && checkProblemsAvailability()) {
      solvedProblem = SolvedProblems(
        id: "${problemList![problemIndex].id!}-${student.email!}",
        uid: uid,
        courseId: courseId,
        topics: problemList![problemIndex].topics,
        solvingTime: [],
        nextRepeat: '',
        failureTime: [],
        needHelp: [],
        solvingDate: [],
        answer: [],
      );
    }
  }

  String _nextRepeat() {
    if (needHelp) {
      return DateTime.now().add(const Duration(days: 1)).toString();
    } else if (DateTime.now().difference(startCounting).inSeconds >
        problemList![problemIndex].time * 60) {
      return DateTime.now().add(const Duration(days: 2)).toString();
    } else if (solvedProblem.failureTime.isNotEmpty) {
      if (DateTime.parse(solvedProblem.failureTime.last).day ==
          DateTime.now().day) {
        return DateTime.now().add(const Duration(days: 3)).toString();
      }
    }
    return DateTime.now().add(const Duration(days: 30)).toString();
  }

  _resetVariables() {
    needHelp = false;
    startCounting = DateTime.now();
    _createSolvedProblemInstance();
  }

  showNeedHelpList() {
    solvedProblem.needHelp.add(DateTime.now().toString());
    needHelp = true;
    emit(NeedHelpVideosLoaded());
  }

  recordFailureTime() {
    solvedProblem.failureTime.add(DateTime.now().toString());
  }

  Future<void> submitSolution(String? solutionController) async {
    await _updatingStudentData();
    _storeSubmissionDataInInstance(solutionController);
    emit(Loading());
    try {
      await problemsRepository.submitSolution(
        solution: solvedProblem,
        path: ApiPath.solvedProblems(
          uid,
          problemList![problemIndex].id!,
        ),
      );
      await _incrementNeedReviewCounter(solutionController);
      await _addProblemId2SolutionsNeedingReview();
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
    _showRepeatedProblems();
    _resetVariables();
    emit(DataLoaded(problemList, student, solutionList));
  }

  void _storeSubmissionDataInInstance(String? solutionController) {
    solvedProblem.solvingDate.add(DateTime.now().toString());
    //Stop storing the same answer
    (!needReview && solvedProblem.answer.isNotEmpty)
        ? null
        : solvedProblem.answer.add(Answer(answer: solutionController));
    solvedProblem.solvingTime
        .add(DateTime.now().difference(startCounting).inSeconds);
    solvedProblem = solvedProblem.copyWith(
      nextRepeat: _nextRepeat(),
      needReview: needReview,
    );
  }

  Future<void> pickImage(ImageSource source) async {
    emit(Loading());
    final XFile? pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        imgPath = await pickedImg.readAsBytes();
        imgName = basename(pickedImg.path);
        await uploadImage(
          imgName: imgName,
          imgPath: imgPath,
        );
        emit(ImageLoaded());
        submitSolution(null);
      } else {
        emit(NoImageSelected());
      }
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
  }

  Future<void> uploadImage({
    required String imgName,
    required Uint8List imgPath,
  }) async {
    final storageRef = FirebaseStorage.instance.ref(
        "Solutions/${student.email}/$problemId/${documentIdFromLocalData()}/$imgName"); // Upload image to firebase storage
    UploadTask uploadTask =
        storageRef.putData(imgPath); // use this code if u are using flutter web
    TaskSnapshot snap = await uploadTask;
    await getImgURL(snap);
  }

  String? imgURL;
  Future<void> getImgURL(TaskSnapshot snap) async {
    imgURL = await snap.ref.getDownloadURL(); // Get img url
  }

  validateSolution(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your solution';
    } else if (checkSolutionIfNeedReview(value)) {
      recordFailureTime();
      return 'Wrong Answer!';
    }
    return null;
  }

  bool checkSolutionIfNeedReview(String value) {
    return !solution.contains(value) && !needReview;
  }

  String get problemId => problemList![problemIndex].id!;
  String get title => problemList![problemIndex].title;
  int get expectedTime => problemList![problemIndex].time;
  String get problem => problemList![problemIndex].problem;
  List<String> get solution => problemList![problemIndex].solutions;
  bool get needReview => problemList![problemIndex].needReview;
  List<String> get videos => (problemList![problemIndex].videos)
      .map((item) => item as String)
      .toList();
  String get userScore => score.toString();
}
