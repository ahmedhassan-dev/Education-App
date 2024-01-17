import 'package:education_app/controllers/database_controller.dart';
import 'package:education_app/models/courses_model.dart';
import 'package:education_app/models/problems.dart';
import 'package:education_app/models/solved_problems.dart';
import 'package:education_app/services/firestore_services.dart';
import 'package:education_app/views/widgets/main_dialog.dart';
import 'package:education_app/views/widgets/need_help_list.dart';
import 'package:education_app/views/widgets/problem_timer.dart';
import 'package:flutter/material.dart';
import 'package:education_app/views/widgets/main_button.dart';
import 'package:provider/provider.dart';

class ProblemPage extends StatefulWidget {
  final CoursesModel courseList;
  const ProblemPage({super.key, required this.courseList});

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  FirestoreServices service = FirestoreServices.instance;
  Future<List<Problems>>? problemList;
  List<Problems>? retrievedProblemList;
  bool isLoading = true;
  bool needHelp = false;
  int problemIndex = 0;
  Duration solvingTime = const Duration(minutes: 0);
  DateTime startCounting = DateTime.now();
  List<DateTime> failureTime = [DateTime.parse("2000-01-01")];
  final _formKey = GlobalKey<FormState>();
  final _solutionController = TextEditingController();
  SolvedProblems? solvedProblems;

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    setState(() {
      isLoading = false;
    });
    retrievedProblemList =
        await service.retrieveProblems(subject: widget.courseList.subject);
    setState(() {
      startCounting = DateTime.now();
      isLoading = true;
    });
  }

  @override
  void dispose() {
    _solutionController.dispose();
    super.dispose();
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
        final solutionData = SolvedProblems(
          id: solvedProblems != null
              ? solvedProblems!.id
              : retrievedProblemList![problemIndex].problemId,
          answer: _solutionController.text.trim(),
          solvingTime: DateTime.now().difference(startCounting).inSeconds,
          nextRepeat: DateTime.now(),
          topics: retrievedProblemList![problemIndex].topics,
          failureTime: failureTime,
          needHelp: [DateTime.parse("2000-01-01")],
          solvingDate: [DateTime.now()],
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
          problemIndex += 1;
          needHelp = false;
          _solutionController.text = "";
          startCounting = DateTime.now();
          failureTime = [DateTime.parse("2000-01-01")];
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
                                        failureTime[0] ==
                                                DateTime.parse("2000-01-01")
                                            ? failureTime[0] = DateTime.now()
                                            : failureTime.add(DateTime.now());
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
