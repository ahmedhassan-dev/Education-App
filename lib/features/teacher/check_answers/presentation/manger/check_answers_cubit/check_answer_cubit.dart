import 'package:education_app/features/problems/data/models/answer.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/presentation/manger/notifications_cubit/notifications_cubit.dart';
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

  late BuildContext context;
  bool hasNote = false;

  Future<void> checkAnswer(BuildContext context, String solutionId,
      TextEditingController noteController, String status) async {
    this.context = context;
    addNoteIfAvailable(noteController.text);
    noteController.text = "";
    solutions()[needReviewIdx].studentAnswer.last.status = status;
    solutions()[needReviewIdx].updateNextRepeatTimeIfWrongAnswer(status);
    var result = await checkAnswersRepo.updateAnswers(
        solutions()[needReviewIdx].solvedProblemid,
        solutions()[needReviewIdx].studentAnswer,
        solutions()[needReviewIdx].nextRepeat);
    result.fold((e) {
      debugPrint(e.toString());
      emit(CheckAnswerFailure(errorMsg: e.toString()));
    }, (s) async {
      status == "valid" ? addSolutionToProblem() : null;
      _updateCourse(solutionId);
      await handleNotificationSystem(status);
      emit(AnswerUpdated());
      isLastSolution() ? emit(AllSolutionsChecked()) : showNewData();
    });
  }

  bool isLastSolution() => needReviewIdx >= solutions().length - 1;

  Future handleNotificationSystem(String status) async {
    NotificationsCubit notificationsCubit = context.read<NotificationsCubit>();
    bool isNew = notificationsCubit.notification!.isNewClass();
    updateNotificationObject(notificationsCubit, status);
    isNew
        ? await notificationsCubit.addStudentNotification()
        : await notificationsCubit.updateStudentNotification();

    if (isLastSolution()) return;

    if (solutions()[needReviewIdx].studentID !=
        solutions()[needReviewIdx + 1].studentID) {
      notificationsCubit
          .handleCurrentNotification(solutions()[needReviewIdx + 1].studentID);
    }
  }

  Future<void> updateNotificationObject(
      NotificationsCubit notificationsCubit, String status) async {
    if (status == "valid") {
      notificationsCubit.notification!.validSolvedProblemsId!
          .add(solutions()[needReviewIdx].solvedProblemid);
      notificationsCubit.notification!.score +=
          currentProblem().problemScoreNum;
      notificationsCubit.notification!
          .copyWith(studentId: solutions()[needReviewIdx].studentID);
    } else {
      notificationsCubit.notification!.wrongSolvedProblemsId!
          .add(solutions()[needReviewIdx].solvedProblemid);
      notificationsCubit.notification!.copyWith(
        studentId: solutions()[needReviewIdx].studentID,
      );
    }
  }

  void addNoteIfAvailable(String note) {
    if (hasNote) {
      solutions()[needReviewIdx].studentAnswer.last.teacherNotes = note;
      hasNote = false;
    }
  }

  void showNewData() {
    needReviewIdx += 1;
    int problemId = solutions()[needReviewIdx].problemId;
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
    return context.read<FetchProblemsCubit>().currentProblem;
  }
}
