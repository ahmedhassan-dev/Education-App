import 'package:education_app/models/courses_model.dart';
import 'package:education_app/models/problems.dart';
import 'package:education_app/services/firestore_services.dart';
import 'package:education_app/views/widgets/need_help_list.dart';
import 'package:education_app/views/widgets/problem_timer.dart';
import 'package:flutter/material.dart';
import 'package:education_app/views/widgets/main_button.dart';

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
  final _solutionController = TextEditingController();

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
      isLoading = true;
    });
  }

  @override
  void dispose() {
    _solutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                              const ProblemTimer()
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
                              TextFormField(
                                controller: _solutionController,
                                decoration: const InputDecoration(
                                  labelText: 'Solution',
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                                validator: (value) => value!.isNotEmpty
                                    ? null
                                    : 'Please enter your solution',
                              ),
                              const SizedBox(height: 16.0),
                              MainButton(
                                  text: "Submit",
                                  onTap: () {
                                    setState(() {
                                      problemIndex += 1;
                                    });
                                  }),
                              needHelp
                                  ? NeedHelpList(
                                      solutions:
                                          retrievedProblemList![1].videos)
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
