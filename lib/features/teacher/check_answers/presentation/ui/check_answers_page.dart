import 'package:cached_network_image/cached_network_image.dart';
import 'package:education_app/core/helpers/context_extension.dart';
import 'package:education_app/core/helpers/spacing.dart';
import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/core/theming/styles.dart';
import 'package:education_app/core/widgets/main_button.dart';
import 'package:education_app/core/widgets/show_loading_indicator.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/presentation/manger/fetch_problems_cubit/fetch_problems_cubit.dart';
import 'package:education_app/features/teacher/check_answers/presentation/manger/fetch_solved_problems_cubit/fetch_solved_problems_cubit.dart';
import 'package:education_app/features/teacher/check_answers/presentation/manger/fetch_student_data_cubit/fetch_student_data_cubit.dart';
import 'package:education_app/features/teacher/check_answers/presentation/ui/widgets/check_answer_buttons.dart';
import 'package:education_app/features/teacher/check_answers/presentation/ui/widgets/check_answers_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../manger/check_answers_cubit/check_answer_cubit.dart';

class CheckAnswersPage extends StatefulWidget {
  final Courses course;
  const CheckAnswersPage({super.key, required this.course});

  @override
  State<CheckAnswersPage> createState() => _CheckAnswersPageState();
}

class _CheckAnswersPageState extends State<CheckAnswersPage> {
  late NeedReviewSolutionsEntity solution;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1)).then((e) async {
      if (!mounted) return;
      await context.read<FetchProblemsCubit>().fetchProblems(
          widget.course.getProblemIdsFromSolutionsNeedingReview());
      if (!mounted) return;
      await context
          .read<FetchSolvedProblemsCubit>()
          .fetchSolvedProblems(widget.course.solutionsNeedingReview, context);
    });

    super.initState();
  }

  Widget buildBlocWidget(BuildContext context) {
    int needReviewIdx = context.watch<CheckAnswerCubit>().needReviewIdx;
    return BlocConsumer<CheckAnswerCubit, CheckAnswerState>(
      listener: (BuildContext context, CheckAnswerState state) {},
      builder: (context, state) {
        if (state is AllSolutionsChecked) {
          return const Scaffold(
            body: Center(
              child: Text("❤️You have checked all answers❤️"),
            ),
          );
        }
        return BlocBuilder<FetchSolvedProblemsCubit, FetchSolvedProblemsState>(
            builder: (context, state) {
          return Scaffold(
            // NestedScrollView(
            //   headerSliverBuilder:
            //       (BuildContext context, bool innerBoxIsScrolled) => [
            //     CheckAnswersAppBar(
            //       context: context,
            //     )
            //   ],
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CheckAnswersAppBar(
                    context: context,
                  ),
                  verticalSpace(10),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    horizontalSpace(20),
                    BlocBuilder<FetchProblemsCubit, FetchProblemsState>(
                      builder: (context, state) {
                        if (state is ShowCurrentProblem) {
                          ProblemsEntity problem = state.problem;
                          return Text(
                              "${problem.problemId}. ${problem.problemTitle}",
                              style: Styles.titleLarge22);
                        } else if (state is NeedReviewProblemsFailure) {
                          return Text(state.errorMsg,
                              style: Styles.titleLarge22);
                        }
                        return const ShowLoadingIndicator();
                      },
                    )
                  ]),
                  verticalSpace(30),
                  showAnswerWidget(needReviewIdx),
                  verticalSpace(40),
                  GestureDetector(
                    onTap: () {
                      final TextEditingController controller =
                          TextEditingController();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: AppColors.backGroundColor,
                        builder: (BuildContext context) {
                          return FractionallySizedBox(
                            heightFactor: 0.7,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32.0,
                              ),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    20.verticalSpace,
                                    const Text(
                                      "Add a note to your student",
                                      style: Styles.bodyLarge16,
                                    ),
                                    30.verticalSpace,
                                    TextField(
                                      controller: controller,
                                      maxLines: null,
                                      maxLength: 200,
                                      expands: false,
                                    ),
                                    50.verticalSpace,
                                    MainButton(
                                        text: "Send",
                                        onTap: () {
                                          context.pop();
                                        })
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text("Say some thing to your student",
                        style: Styles.titleLarge22
                            .copyWith(decoration: TextDecoration.underline)),
                  ),
                  verticalSpace(30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CheckAnswerButton(
                        onTap: () {
                          context
                              .read<CheckAnswerCubit>()
                              .validAnswer(context, solution.solvedProblemid);
                        },
                        color: AppColors.acceptedButtonColor,
                        icon: Icons.check,
                      ),
                      horizontalSpace(100),
                      CheckAnswerButton(
                        onTap: () {},
                        color: AppColors.primaryColor,
                        icon: Icons.close,
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  bool imgUrl = true;

  Widget showAnswerWidget(int needReviewIdx) {
    return BlocBuilder<FetchSolvedProblemsCubit, FetchSolvedProblemsState>(
      builder: (context, state) {
        if (state is NeedReviewSolutionsLoaded) {
          List<NeedReviewSolutionsEntity> needReviewSolutions =
              (state).needReviewSolutions;
          solution = needReviewSolutions[needReviewIdx];
          context
              .read<FetchStudentDataCubit>()
              .fetchStudentData(docName: solution.studentID);
          return solution.studentAnswer.last.answer == null
              ? InteractiveViewer(
                  child: CachedNetworkImage(
                    imageUrl: solution.studentAnswer.last.solutionImgURL!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    solution.studentAnswer.last.answer.toString(),
                    style: Styles.titleLarge22,
                  ),
                );
        } else if (state is NeedReviewSolutionsFailure) {
          const Center(
            child: Text("Some thing went wrong"),
          );
        }
        return const ShowLoadingIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildBlocWidget(context);
  }
}
