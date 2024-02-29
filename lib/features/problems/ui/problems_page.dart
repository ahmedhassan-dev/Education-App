import 'package:audioplayers/audioplayers.dart';
import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/features/problems/logic/problems_cubit.dart';
import 'package:education_app/core/helpers/spacing.dart';
import 'package:education_app/features/courses/data/models/courses_model.dart';
import 'package:education_app/features/problems/data/models/solved_problems.dart';
import 'package:education_app/core/constants/assets.dart';
import 'package:education_app/features/problems/ui/widgets/need_help_list.dart';
import 'package:education_app/features/problems/ui/widgets/problem_timer.dart';
import 'package:education_app/features/problems/ui/widgets/text_form_field_with_camera_button.dart';
import 'package:flutter/material.dart';
import 'package:education_app/core/widgets/main_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import "dart:ui" as ui;

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

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
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.scale,
        title: 'Error Submiting Solution',
        desc: e.toString(),
        dialogBackgroundColor: const Color.fromRGBO(42, 42, 42, 1),
      ).show();
    }
  }

  cameraOrGalleryDialog(BuildContext blocContext) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: AppColors.secondaryColor,
          children: [
            SimpleDialogOption(
              onPressed: () {
                BlocProvider.of<ProblemsCubit>(blocContext)
                    .pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
              padding: const EdgeInsets.all(20),
              child: Text(
                "From Camera",
                style: TextStyle(
                  fontSize: 18.sp,
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                BlocProvider.of<ProblemsCubit>(blocContext)
                    .pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
              padding: EdgeInsets.all(20.w),
              child: Text(
                "From Gallary",
                style: TextStyle(
                  fontSize: 18.sp,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<ProblemsCubit, ProblemsState>(
      builder: (context, state) {
        if (state is DataLoaded || state is ImageLoaded) {
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
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
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
                        verticalSpace(10),
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
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                child: Column(
                  children: [
                    Text(
                      context.read<ProblemsCubit>().problem,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    verticalSpace(20),
                    Form(
                        key: _formKey,
                        child: TextFormFieldWithCameraButton(
                          controller: _solutionController,
                          labelText: 'Solution',
                          validator: (String? value) {
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
                          },
                          onTap: () {
                            cameraOrGalleryDialog(context);
                          },
                        )),
                    verticalSpace(16),
                    MainButton(
                        text: "Submit",
                        onTap: () {
                          submitSolution(context);
                        }),
                    BlocProvider.of<ProblemsCubit>(context).imgPath != null
                        ? CircleAvatar(
                            radius: 71,
                            backgroundImage: MemoryImage(
                                BlocProvider.of<ProblemsCubit>(context)
                                    .imgPath!),
                          )
                        : const SizedBox(),
                    verticalSpace(5),
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
        horizontalSpace(5),
        Image.asset(
          AppAssets.starIcon,
          height: 35.h,
        ),
        horizontalSpace(5)
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
