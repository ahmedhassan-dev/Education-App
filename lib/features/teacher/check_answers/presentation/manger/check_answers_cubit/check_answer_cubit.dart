import 'package:education_app/features/problems/data/models/answer.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../courses/data/models/courses.dart';
import '../../../../courses_student_feedback/logic/courses_student_feedback_cubit.dart';
import '../../../domain/repos/check_answers_repo.dart';
import '../fetch_problems_cubit/fetch_problems_cubit.dart';
import '../fetch_solved_problems_cubit/fetch_solved_problems_cubit.dart';

part 'check_answer_state.dart';

class CheckAnswerCubit extends Cubit<CheckAnswerState> {
  CheckAnswerCubit(this.checkAnswersRepo) : super(CheckAnswerInitial());
  CheckAnswersRepo checkAnswersRepo;
  int needReviewIdx = 0;
  // addNewAnswerToProblems

  late BuildContext context;
  bool hasNote = false;

  void addNoteIfAvailable(BuildContext context, String note) {
    this.context = context;
    if (hasNote) {
      solutions()[needReviewIdx].studentAnswer.last.teacherNotes = note;
      hasNote = false;
    }
  }

  Future<void> validAnswer(BuildContext context, String solutionId) async {
    this.context = context;
    solutions()[needReviewIdx].studentAnswer.last.status = "valid";
    var result = await checkAnswersRepo.updateAnswers(
        solutions()[needReviewIdx].solvedProblemid,
        solutions()[needReviewIdx].studentAnswer);
    result.fold((e) {
      debugPrint(e.toString());
      emit(CheckAnswerFailure(errorMsg: e.toString()));
    }, (s) {
      addSolutionToProblem();
      _updateCourse(solutionId);
      emit(AnswerUpdated());
      needReviewIdx < solutions().length - 1
          ? showNewData()
          : emit(AllSolutionsChecked());
    });
  }

  void showNewData() {
    needReviewIdx += 1;
    int problemId = solutions()[needReviewIdx].getProblemId();
    context.read<FetchProblemsCubit>().showCurrentProblem(problemId);
  }

  void _updateCourse(String solutionId) {
    Courses currentCourse =
        context.read<CoursesStudentFeedbackCubit>().currentCourse;
    checkAnswersRepo.updateCourse(currentCourse.id!, solutionId);
  }

  void addSolutionToProblem() {
    Answer? lastSolution = solutions()[needReviewIdx].studentAnswer.last;
    if (isLastAnswerNotAvailable(lastSolution) ||
        solutionAlreadyExist(lastSolution.answer!)) {
      return;
    }

    checkAnswersRepo.addSolutionToProblem(
        lastSolution.answer!, currentProblem().problemId!);
  }

  /// This will be not availabe if the solution is image answer
  bool isLastAnswerNotAvailable(Answer? lastSolution) {
    return lastSolution == null || lastSolution.answer == null;
  }

  List<NeedReviewSolutionsEntity> solutions() {
    return context.read<FetchSolvedProblemsCubit>().needReviewSolutions;
  }

  bool solutionAlreadyExist(String answer) =>
      currentProblem().problemSolutions.contains(answer);

  ProblemsEntity currentProblem() {
    return context.read<FetchProblemsCubit>().needReviewProblems[needReviewIdx];
  }
}
