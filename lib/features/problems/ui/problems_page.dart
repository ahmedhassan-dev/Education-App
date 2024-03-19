import 'package:audioplayers/audioplayers.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/features/problems/logic/problems_cubit.dart';
import 'package:education_app/core/helpers/spacing.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/problems/data/models/solved_problems.dart';
import 'package:education_app/core/constants/assets.dart';
import 'package:education_app/features/problems/ui/widgets/awesome_dialog.dart';
import 'package:education_app/features/problems/ui/widgets/camera_or_gallery_dialog.dart';
import 'package:education_app/features/problems/ui/widgets/need_help_list.dart';
import 'package:education_app/features/problems/ui/no_problems_available_page.dart';
import 'package:education_app/features/problems/ui/widgets/need_help_text_button.dart';
import 'package:education_app/features/problems/ui/widgets/problem_details_section.dart';
import 'package:education_app/features/problems/ui/widgets/problems_app_bar.dart';
import 'package:education_app/features/problems/ui/widgets/problems_page_drawer.dart';
import 'package:education_app/features/problems/ui/widgets/text_form_field_with_camera_button.dart';
import 'package:flutter/material.dart';
import 'package:education_app/core/widgets/main_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "dart:ui" as ui;

import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    BlocProvider.of<ProblemsCubit>(context)
        .retrieveUserData(subject: widget.course.subject);
    BlocProvider.of<ProblemsCubit>(context)
        .retrieveCourseProblems(courseId: widget.course.id!);
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
          reviewAnswerAwesomeDialog(context).show();
        } else {
          keepGoingAwesomeDialog(context).show();
        }

        await player.play(AssetSource(AppAssets.increasingScoreSound));
        BlocProvider.of<ProblemsCubit>(context)
            .submitSolution(_solutionController.text.trim());

        await Future.delayed(const Duration(seconds: 1), () {});
        if (!mounted) return;
        Navigator.pop(context);

        _solutionController.text = "";
      }
    } catch (e) {
      errorAwesomeDialog(context, e).show();
    }
  }

  Widget buildBlocWidget() {
    return BlocConsumer<ProblemsCubit, ProblemsState>(
        listener: (BuildContext context, ProblemsState state) async {
      if (state is ImageLoaded) {
        reviewAnswerAwesomeDialog(context).show();
        await player.play(AssetSource(AppAssets.increasingScoreSound));
        await Future.delayed(const Duration(seconds: 1), () {});
        if (!mounted) return;
        Navigator.pop(context);
      }
    }, builder: (context, state) {
      if (state is DataLoaded ||
          state is ImageLoaded ||
          state is NeedHelpVideosLoaded) {
        // retrievedProblemList = (state).retrievedProblemList;
        if (BlocProvider.of<ProblemsCubit>(context)
                .checkProblemsAvailability() ==
            true) {
          return buildLoadedProblemsWidgets();
        } else {
          return const NoProblemsAvailablePage();
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
      drawer: const ProblemsPageDrawer(),
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
