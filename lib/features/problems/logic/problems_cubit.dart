import 'dart:collection';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:education_app/features/authentication/data/models/student.dart';
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
  Map<String, dynamic> lastProblemIdx = {};
  Map<String, dynamic> lastProblemTime = {};
  int problemIndex = 0;
  List<Problems>? retrievedProblemList;
  DateTime startCounting = DateTime.now();
  List<String> solvedProblemsList = [];
  late Student studentData;
  List<Problems> problems = [];
  ProblemsRepository problemsRepository;
  List<SolvedProblems>? retrievedSolutionList;
  ProblemsCubit(this.problemsRepository) : super(ProblemsInitial());
  String uid = FirebaseAuth.instance.currentUser!.uid;
  late String courseId;
  SolvedProblems? solvedProblems;
  bool solvedBefore = false;
  Queue<int> prbolemIndexQueue = Queue<int>();
  List<dynamic> failureTime = [];
  List<dynamic> solvingDate = [];
  List<dynamic> needHelpTime = [];
  List<dynamic> solutionImgURL = [];
  bool needHelp = false;
  String nextRepeat = DateTime.now().add(const Duration(days: 30)).toString();
  late Uint8List imgPath;
  late String imgName;

  retrieveUserData({required String subject}) async {
    this.subject = subject;
    await problemsRepository
        .retrieveUserData(path: ApiPath.studentCollection(), docName: uid)
        .then((studentData) {
      this.studentData = studentData;
    });
    initUserData();
  }

  initUserData() {
    score = studentData.totalScore;
    userScores = studentData.userScores;
    lastProblemIdx =
        studentData.lastProblemIdx; //Adding the firebase map to the local map
    lastProblemTime =
        studentData.lastProblemTime; //Adding the firebase map to the local map
    if (studentData.userScores[subject] == null) {
      userScores[subject] = 0;
    }
    if (studentData.lastProblemIdx[subject] == null) {
      lastProblemIdx[subject] = 0; // Adding new subject to the map
      lastProblemTime[subject] = "0"; // Adding new subject to the map
    } else {
      problemIndex = studentData.lastProblemIdx[subject]!;
    }
  }

  updatingStudentData() async {
    if (!solvedBefore) {
      score += retrievedProblemList![problemIndex].scoreNum;
      userScores[subject] =
          userScores[subject] + retrievedProblemList![problemIndex].scoreNum;
      lastProblemIdx[subject] = problemIndex + 1;
      lastProblemTime[subject] = DateTime.now().toString();
      Map<String, dynamic> data = {
        "totalScore": score,
        "userScores": userScores,
        "lastProblemIdx": lastProblemIdx,
        "lastProblemTime": lastProblemTime
      };
      problemsRepository.updatingStudentData(
          path: ApiPath.student(uid), data: data);
    }
  }

  Future<void> retrieveCourseProblems(
      {bool forTeachers = false, required String courseId}) async {
    this.courseId = courseId;
    await problemsRepository
        .retrieveCourseProblems(
            path: ApiPath.problems(), courseId: courseId, sortedBy: 'id')
        .then((retrievedProblemList) {
      this.retrievedProblemList = retrievedProblemList;
    });

    if (!forTeachers) {
      await initRetrievalSolutions();
      startCounting = DateTime.now();
    } else {
      emit(ProblemsLoaded());
    }
  }

  checkProblemsAvailability() =>
      !(retrievedProblemList!.length == problemIndex);

  initRetrievalSolutions() async {
    await problemsRepository
        .retrieveSolvedProblems(
            path: ApiPath.solvedProblemsCollection(uid),
            courseId: courseId,
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
    emit(DataLoaded(retrievedProblemList, studentData, retrievedSolutionList));
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
      problemIndex = studentData.lastProblemIdx[subject]!;
    }
  }

  solvedBeforeFun() {
    problemIndex < retrievedProblemList!.length
        ? solvedBefore =
            solvedProblemsList.contains(retrievedProblemList![problemIndex].id)
        : solvedBefore = false;
  }

  // TODO: Make copywith method in model
  addOldSolution2New() {
    if (solvedBefore) {
      failureTime.addAll(retrievedSolutionList![problemIndex].failureTime);
      solvingDate.addAll(retrievedSolutionList![problemIndex].solvingDate);
      needHelpTime.addAll(retrievedSolutionList![problemIndex].needHelp);
      solutionImgURL
          .addAll(retrievedSolutionList![problemIndex].solutionImgURL);
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
    solutionImgURL = [];
  }

  showNeedHelpList() {
    needHelp = true;
    needHelpTime.add(DateTime.now().toString());
    emit(NeedHelpVideosLoaded());
  }

  recordFailureTime() {
    failureTime.add(DateTime.now().toString());
  }

  Future<void> submitSolution(String? solutionController) async {
    updatingStudentData();
    solvingDate.add(DateTime.now().toString());
    nextRepeatFun();
    try {
      final solutionData = SolvedProblems(
        id: solvedProblems != null
            ? solvedProblems!.id
            : retrievedProblemList![problemIndex].id!,
        courseId: courseId,
        answer: solutionController,
        solvingTime: DateTime.now().difference(startCounting).inSeconds,
        nextRepeat: nextRepeat,
        topics: retrievedProblemList![problemIndex].topics,
        failureTime: failureTime,
        needHelp: needHelpTime,
        solvingDate: solvingDate,
        solutionImgURL: solutionImgURL,
      );
      emit(Loading());
      await problemsRepository.submitSolution(
        solution: solutionData,
        path: ApiPath.solvedProblems(
          uid,
          retrievedProblemList![problemIndex].id!,
        ),
      );
    } catch (e) {
      emit(ErrorOccurred(errorMsg: e.toString()));
    }
    resetVariables();
    showRepeatedProblems();
    solvedBeforeFun();
    addOldSolution2New();
    emit(DataLoaded(retrievedProblemList, studentData, retrievedSolutionList));
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
        "Solutions/${studentData.email}/$problemId/${documentIdFromLocalData()}/$imgName"); // Upload image to firebase storage
    UploadTask uploadTask =
        storageRef.putData(imgPath); // use this code if u are using flutter web
    TaskSnapshot snap = await uploadTask;
    await getImgURL(snap);
  }

  Future<void> getImgURL(TaskSnapshot snap) async {
    final String imgURL = await snap.ref.getDownloadURL(); // Get img url
    solutionImgURL.add(imgURL);
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
    return value != solution && !needReview;
  }

  String get problemId => retrievedProblemList![problemIndex].id!;
  String get title => retrievedProblemList![problemIndex].title;
  int get expectedTime => retrievedProblemList![problemIndex].time;
  String get problem => retrievedProblemList![problemIndex].problem;
  String get solution => retrievedProblemList![problemIndex].solution;
  bool get needReview => retrievedProblemList![problemIndex].needReview;
  List<String> get videos => (retrievedProblemList![problemIndex].videos)
      .map((item) => item as String)
      .toList();
  String get userScore => score.toString();
}
