import 'dart:collection';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/controllers/database_controller.dart';
import 'package:education_app/models/courses_model.dart';
import 'package:education_app/models/problems.dart';
import 'package:education_app/models/solved_problems.dart';
import 'package:education_app/services/firestore_services.dart';
import 'package:education_app/utilities/api_path.dart';
import 'package:education_app/utilities/assets.dart';
import 'package:education_app/views/widgets/main_dialog.dart';
import 'package:education_app/views/widgets/need_help_list.dart';
import 'package:education_app/views/widgets/problem_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:education_app/views/widgets/main_button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProblemPage extends StatefulWidget {
  final CoursesModel courseList;
  const ProblemPage({super.key, required this.courseList});

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  FirestoreServices service = FirestoreServices.instance;
  Map userData = {};
  int score = 0;
  Map<String, String> lastProblem = {};
  Map<String, dynamic> lastProblemIdx = {};
  Map<String, dynamic> lastProblemTime = {};
  List<Problems>? retrievedProblemList;
  List<SolvedProblems>? retrievedSolutionList;
  List<String> solvedProblemsList = [];
  bool isLoading = true;
  bool needHelp = false;
  int problemIndex = 0;
  Duration solvingTime = const Duration(minutes: 0);
  DateTime startCounting = DateTime.now();
  List<String> failureTime = [];
  List<String> solvingDate = [];
  List<String> needHelpTime = [];
  String nextRepeat = DateTime.now().add(const Duration(days: 30)).toString();
  final _formKey = GlobalKey<FormState>();
  final _solutionController = TextEditingController();
  SolvedProblems? solvedProblems;
  bool solvedBefore = false;
  Queue<int> prbolemIndexQueue = Queue<int>();

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    retrieveData();
    _initRetrieval();
  }

  retrieveData() async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    userData = snapshot.data()!;
    score = userData["userScore"];
    lastProblemIdx =
        userData["lastProblemIdx"]; //Adding the firebase map to the local map
    lastProblemTime =
        userData["lastProblemTime"]; //Adding the firebase map to the local map
    if (userData["lastProblemIdx"][widget.courseList.subject] == null) {
      lastProblemIdx[widget.courseList.subject] =
          0; // Adding new subject to the map
      lastProblemTime[widget.courseList.subject] =
          "0"; // Adding new subject to the map
    } else {
      problemIndex = userData["lastProblemIdx"][widget.courseList.subject];
    }
  }

  updatingUserData() async {
    if (!solvedBefore) {
      score += retrievedProblemList![problemIndex].scoreNum;
      lastProblemIdx[widget.courseList.subject] = problemIndex + 1;
      lastProblemTime[widget.courseList.subject] = DateTime.now().toString();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "userScore": score,
        "lastProblemIdx": lastProblemIdx,
        "lastProblemTime": lastProblemTime
      });
    }
  }

  Future<void> _initRetrieval() async {
    setState(() {
      isLoading = false;
    });
    retrievedProblemList = await service.retrieveProblems(
      subject: widget.courseList.subject,
      path: ApiPath.problems(),
      sortedBy: 'problemId',
    );

    await _initRetrievalSolutions();
    setState(() {
      startCounting = DateTime.now();
      isLoading = true;
    });
  }

  Future<void> _initRetrievalSolutions() async {
    retrievedSolutionList = await service.retrieveSolvedProblems(
        subject: widget.courseList.subject,
        sortedBy: 'id',
        mainCollectionPath: 'users',
        uid: FirebaseAuth.instance.currentUser!.uid,
        collectionPath: 'solvedProblems');
    for (var element in retrievedSolutionList!) {
      solvedProblemsList.add(element.id);
    }
    nextRepeatProblemsIndex();
    solvedBeforeFun();
    addOldSolution2New();
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
        (formatter.format(DateTime.parse(
                    lastProblemTime[widget.courseList.subject])) ==
                formatter.format(now) ||
            retrievedProblemList!.length == problemIndex)) {
      problemIndex = prbolemIndexQueue.first;
      waitForSolving = true;
    } else if (prbolemIndexQueue.isEmpty) {
      problemIndex = userData["lastProblemIdx"][widget.courseList.subject];
    }
  }

  solvedBeforeFun() {
    problemIndex < retrievedProblemList!.length
        ? solvedBefore = solvedProblemsList
            .contains(retrievedProblemList![problemIndex].problemId)
        : solvedBefore = false;
  }

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

  @override
  void dispose() {
    _solutionController.dispose();
    player.dispose();
    super.dispose();
  }

  resetVariables() {
    problemIndex += 1;
    needHelp = false;
    _solutionController.text = "";
    startCounting = DateTime.now();
    failureTime = [];
    solvingDate = [];
    needHelpTime = [];
  }

  Future<void> submitSolution(Database database) async {
    try {
      if (_formKey.currentState!.validate()) {
        if (_solutionController.text.trim() !=
                retrievedProblemList![problemIndex].solution &&
            retrievedProblemList![problemIndex].needReview == true) {
          MainDialog(
                  context: context,
                  title: 'We will review your answer soon❤️!',
                  content: 'Keep Going')
              .showAlertDialog();
        } else {
          MainDialog(
                  context: context,
                  title: 'Nice Answer😊!',
                  content: 'Keep Going')
              .showAlertDialog();
        }

        await player.play(AssetSource(AppAssets.increasingScoreSound));

        updatingUserData();
        solvingDate.add(DateTime.now().toString());
        nextRepeatFun();
        final solutionData = SolvedProblems(
          id: solvedProblems != null
              ? solvedProblems!.id
              : retrievedProblemList![problemIndex].problemId,
          answer: _solutionController.text.trim(),
          solvingTime: DateTime.now().difference(startCounting).inSeconds,
          nextRepeat: nextRepeat,
          topics: retrievedProblemList![problemIndex].topics,
          failureTime: failureTime,
          needHelp: needHelpTime,
          solvingDate: solvingDate,
        );
        await database.submitSolution(solutionData);
        const Center(
            child: CircularProgressIndicator(
          color: Colors.black,
        ));
        await Future.delayed(const Duration(seconds: 1), () {});
        if (!mounted) return;
        Navigator.pop(context);
        setState(() {
          resetVariables();
          showRepeatedProblems();
          solvedBeforeFun();
          addOldSolution2New();
        });
      }
    } catch (e) {
      MainDialog(
              context: context,
              title: 'Error Submiting Solution',
              content: e.toString())
          .showAlertDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context);
    return isLoading
        ? retrievedProblemList!.length == problemIndex
            ? Center(
                child: Text(
                  "❤️Stay Tuned❤️",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text(
                    widget.courseList.subject,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    Text(
                      score.toString(),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Image.asset(
                      AppAssets.starIcon,
                      height: 35,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                drawer: Drawer(
                  // Add a ListView to the drawer. This ensures the user can scroll
                  // through the options in the drawer if there isn't enough vertical
                  // space to fit everything.
                  child: ListView(
                    // Important: Remove any padding from the ListView.
                    padding: EdgeInsets.zero,
                    children: const [
                      DrawerHeader(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(42, 42, 42, 1),
                        ),
                        child: Text('User'),
                      ),
                    ],
                  ),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${retrievedProblemList![problemIndex].problemId}. ${retrievedProblemList![problemIndex].title}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 30,
                                      ),
                                      Text(
                                        widget.courseList.subject,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  )
                                ],
                              ),
                              ProblemTimer(
                                problemIndex: problemIndex,
                                expectedTime:
                                    retrievedProblemList![problemIndex].time,
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Text(
                                retrievedProblemList![problemIndex].problem,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Form(
                                key: _formKey,
                                child: TextFormField(
                                    controller: _solutionController,
                                    decoration: const InputDecoration(
                                      labelText: 'Solution',
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your solution';
                                      } else if (value !=
                                              retrievedProblemList![
                                                      problemIndex]
                                                  .solution &&
                                          retrievedProblemList![problemIndex]
                                                  .needReview ==
                                              false) {
                                        failureTime
                                            .add(DateTime.now().toString());
                                        return 'Wrong Answer!';
                                      }
                                      return null;
                                    }),
                              ),
                              const SizedBox(height: 16.0),
                              MainButton(
                                  text: "Submit",
                                  onTap: () {
                                    submitSolution(database);
                                  }),
                              needHelp
                                  ? NeedHelpList(
                                      solutions:
                                          retrievedProblemList![problemIndex]
                                              .videos)
                                  : TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.blue,
                                      ),
                                      onPressed: () {
                                        needHelpTime
                                            .add(DateTime.now().toString());
                                        setState(() {
                                          needHelp = true;
                                        });
                                      },
                                      child: const Text(
                                        'Need Help?',
                                        style: TextStyle(
                                          fontSize: 20,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.blue,
                                          decorationThickness: 2,
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
        : const Center(
            child: CircularProgressIndicator(
            color: Colors.white,
          ));
  }
}
