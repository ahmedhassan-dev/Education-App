import 'package:audioplayers/audioplayers.dart';
import 'package:education_app/business_logic/problems_cubit/problems_cubit.dart';
import 'package:education_app/data/models/courses_model.dart';
import 'package:education_app/data/models/solved_problems.dart';
import 'package:education_app/utilities/assets.dart';
import 'package:education_app/presentation/widgets/main_dialog.dart';
import 'package:education_app/presentation/widgets/need_help_list.dart';
import 'package:education_app/presentation/widgets/problem_timer.dart';
import 'package:flutter/material.dart';
import 'package:education_app/presentation/widgets/main_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import "dart:ui" as ui;

class ProblemPage extends StatefulWidget {
  final CoursesModel courseList;
  const ProblemPage({super.key, required this.courseList});

  @override
  State<ProblemPage> createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  final _formKey = GlobalKey<FormState>();
  final _solutionController = TextEditingController();
  SolvedProblems? solvedProblems;

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProblemsCubit>(context)
        .retrieveUserData(subject: widget.courseList.subject);
    BlocProvider.of<ProblemsCubit>(context).retrieveSubjectProblems();
  }

  @override
  void dispose() {
    _solutionController.dispose();
    player.dispose();
    super.dispose();
  }

  Future<void> submitSolution(context) async {
    try {
      if (_formKey.currentState!.validate()) {
        if (_solutionController.text.trim() !=
                BlocProvider.of<ProblemsCubit>(context).solution &&
            BlocProvider.of<ProblemsCubit>(context).needReview) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.infoReverse,
            animType: AnimType.scale,
            title: 'Keep Going😉',
            desc: 'We will review your answer soon❤️!',
            dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1),
            // btnCancelOnPress: () {},
            // btnOkOnPress: () {},
          ).show();
        } else {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            title: 'Nice Answer😊!',
            desc: 'Keep Going❤️',
            dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1),
          ).show();
        }

        await player.play(AssetSource(AppAssets.increasingScoreSound));
        // await database.submitSolution(solutionData);
        BlocProvider.of<ProblemsCubit>(context)
            .submitSolution(_solutionController.text.trim());

        await Future.delayed(const Duration(seconds: 1), () {});
        if (!mounted) return;
        Navigator.pop(context);

        _solutionController.text = "";
      }
    } catch (e) {
      MainDialog(
              context: context,
              title: 'Error Submiting Solution',
              content: e.toString())
          .showAlertDialog();
    }
  }

  Widget buildBlocWidget() {
    return BlocBuilder<ProblemsCubit, ProblemsState>(
      builder: (context, state) {
        if (state is DataLoaded) {
          // retrievedProblemList = (state).retrievedProblemList;
          // userData = (state).userData;
          // retrievedSolutionList = (state).retrievedSolutionList;
          if (BlocProvider.of<ProblemsCubit>(context)
                  .checkProblemsAvailability() ==
              true) {
            return buildLoadedProblemsWidgets();
          } else {
            return noProblemsAvailable();
          }
        } else {
          return showLoadingIndicator();
        }
      },
    );
  }

  Widget buildLoadedProblemsWidgets() {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            [appBar()],
        body: SingleChildScrollView(
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
                          "${context.read<ProblemsCubit>().problemId}. ${context.read<ProblemsCubit>().title}",
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
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
                      problemIndex: context.read<ProblemsCubit>().problemIndex,
                      expectedTime: context.read<ProblemsCubit>().expectedTime,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      context.read<ProblemsCubit>().problem,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
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
                            fillColor: Color.fromRGBO(42, 42, 42, 1),
                            filled: true,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your solution';
                            } else if (value !=
                                    context.read<ProblemsCubit>().solution &&
                                !context.read<ProblemsCubit>().needReview) {
                              BlocProvider.of<ProblemsCubit>(context)
                                  .recordFailureTime();
                              return 'Wrong Answer!';
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(height: 16.0),
                    MainButton(
                        text: "Submit",
                        onTap: () {
                          submitSolution(context);
                        }),
                    context.read<ProblemsCubit>().needHelp
                        ? NeedHelpList(
                            solutions: context.read<ProblemsCubit>().videos)
                        : TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              // needHelpTime.add(DateTime.now().toString());
                              setState(() {
                                BlocProvider.of<ProblemsCubit>(context)
                                    .showNeedHelpList();
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
    );
  }

  Widget showLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }

  Widget noProblemsAvailable() {
    return Center(
      child: Text(
        "❤️Stay Tuned❤️",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }

  Widget appBar() {
    return SliverAppBar(
      title: Text(
        widget.courseList.subject,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        Text(
          context.read<ProblemsCubit>().userScore,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    Size s = ui.window.physicalSize / ui.window.devicePixelRatio;
    bool landscape = s.width > s.height;
    if (landscape) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
    return buildBlocWidget();
  }
}
