import 'package:education_app/core/helpers/spacing.dart';
import 'package:education_app/core/theming/app_colors.dart';
import 'package:education_app/core/theming/styles.dart';
import 'package:education_app/features/teacher/check_answers/presentation/manger/fetch_solved_problems_cubit/fetch_solved_problems_cubit.dart';
import 'package:education_app/features/teacher/check_answers/presentation/ui/no_answers_available.dart';
import 'package:education_app/features/teacher/check_answers/presentation/ui/widgets/check_answer_buttons.dart';
import 'package:education_app/features/teacher/check_answers/presentation/ui/widgets/check_answers_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckAnswersPage extends StatefulWidget {
  const CheckAnswersPage({super.key});

  @override
  State<CheckAnswersPage> createState() => _CheckAnswersPageState();
}

class _CheckAnswersPageState extends State<CheckAnswersPage> {
  Widget buildBlocWidget(BuildContext context) {
    return BlocConsumer<FetchSolvedProblemsCubit, FetchSolvedProblemsState>(
        listener: (context, state) {
      // TODO: implement listener
    }, builder: (context, state) {
      // if (state is AnswerImageLoaded) {
      return Scaffold(
        body: NestedScrollView(
          headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) => [
            CheckAnswersAppBar(
              context: context,
            )
          ],
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                verticalSpace(10),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  horizontalSpace(20),
                  const Text("problemId. title", style: Styles.titleLarge22)
                ]),
                verticalSpace(40),
                showAnswerWidget(),
                verticalSpace(80),
                GestureDetector(
                  onTap: () {},
                  child: Text("Say some thing to your student",
                      style: Styles.titleLarge22
                          .copyWith(decoration: TextDecoration.underline)),
                ),
                verticalSpace(50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CheckAnswerButtons(
                      onTap: () {},
                      color: AppColors.acceptedButtonColor,
                      icon: Icons.check,
                    ),
                    horizontalSpace(100),
                    CheckAnswerButtons(
                      onTap: () {},
                      color: AppColors.primaryColor,
                      icon: Icons.close,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  bool imgUrl = true;

  Widget showAnswerWidget() {
    return imgUrl
        ? Image.asset("assets/logo.jpg")
        : Container(
            decoration: BoxDecoration(
                color: AppColors.secondaryColor,
                borderRadius: BorderRadius.circular(20)),
            child: const Text(
              "Ans",
              style: Styles.bodyMedium14,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return buildBlocWidget(context);
  }
}
