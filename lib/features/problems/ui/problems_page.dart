import "dart:ui" as ui;

import 'package:audioplayers/audioplayers.dart';
import 'package:education_app/core/widgets/no_data_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:education_app/core/constants/assets.dart';
import 'package:education_app/core/helpers/spacing.dart';
import 'package:education_app/core/widgets/awesome_dialog.dart';
import 'package:education_app/core/widgets/main_button.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/problems/data/models/solved_problems.dart';
import 'package:education_app/features/problems/logic/problems_cubit.dart';
import 'package:education_app/features/problems/ui/widgets/camera_or_gallery_dialog.dart';
import 'package:education_app/features/problems/ui/widgets/need_help_list.dart';
import 'package:education_app/features/problems/ui/widgets/need_help_text_button.dart';
import 'package:education_app/features/problems/ui/widgets/problem_details_section.dart';
import 'package:education_app/features/problems/ui/widgets/problems_app_bar.dart';
import 'package:education_app/features/problems/ui/widgets/text_form_field_with_camera_button.dart';

class ProblemPage extends StatefulWidget {
  final Courses course;
  const ProblemPage({super.key, required this.course});

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
    BlocProvider.of<ProblemsCubit>(context).retrieveStudentData(
        subject: widget.course.subject, courseId: widget.course.id!);
    BlocProvider.of<ProblemsCubit>(context).retrieveCourseProblems();
  }

  @override
  void dispose() {
    _solutionController.dispose();
    player.dispose();
    super.dispose();
  }

  Future<void> submitSolution(BuildContext context) async {
    try {
      if (_formKey.currentState!.validate()) {
        if (!context
                .read<ProblemsCubit>()
                .solution
                .contains(_solutionController.text.trim()) &&
            context.read<ProblemsCubit>().needReview) {
          reviewAnswerAwesomeDialog(context).show();
        } else {
          keepGoingAwesomeDialog(context).show();
        }

        final navigator = Navigator.of(context);
        await player.play(AssetSource(AppAssets.increasingScoreSound));
        BlocProvider.of<ProblemsCubit>(context)
            .submitSolution(_solutionController.text.trim());
        await Future.delayed(const Duration(seconds: 1), () {});
        if (!mounted) return;
        navigator.pop();

        _solutionController.text = "";
      }
    } catch (e) {
      errorAwesomeDialog(context, e, title: "Error Submiting Solution").show();
    }
  }

  Widget buildBlocWidget() {
    return BlocConsumer<ProblemsCubit, ProblemsState>(
        listener: (BuildContext context, ProblemsState state) async {
      if (state is ImageLoaded) {
        reviewAnswerAwesomeDialog(context).show();
        final navigator = Navigator.of(context);
        await player.play(AssetSource(AppAssets.increasingScoreSound));
        await Future.delayed(const Duration(seconds: 1));
        navigator.pop();
      }
    }, builder: (context, state) {
      if (state is DataLoaded ||
          state is ImageLoaded ||
          state is NeedHelpVideosLoaded ||
          state is NoImageSelected) {
        // retrievedProblemList = (state).retrievedProblemList;
        if (BlocProvider.of<ProblemsCubit>(context)
                .checkProblemsAvailability() ==
            true) {
          return buildLoadedProblemsWidgets();
        } else {
          return const NoDataWidget(
            message: "❤️Stay Tuned❤️",
          );
        }
      } else {
        return const ShowLoadingIndicator();
      }
    });
  }

  Widget buildLoadedProblemsWidgets() {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) =>
            [
          ProblemsAppBar(
            context: context,
            subject: widget.course.subject,
          )
        ],
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              ProblemDetailsSection(
                  context: context, subject: widget.course.subject),
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
                          needReview: BlocProvider.of<ProblemsCubit>(context)
                              .needReview,
                          validator: BlocProvider.of<ProblemsCubit>(context)
                              .validateSolution,
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
                    verticalSpace(5),
                    context.read<ProblemsCubit>().needHelp
                        ? NeedHelpList(
                            solutions: context.read<ProblemsCubit>().videos)
                        : NeedHelpTextButton(
                            context: context,
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size s = ui.PlatformDispatcher.instance.views.first.physicalSize /
        ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
    bool landscape = s.width > s.height;
    if (landscape) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
    return buildBlocWidget();
  }
}
