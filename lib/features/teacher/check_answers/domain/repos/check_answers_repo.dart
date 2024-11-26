import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../problems/data/models/answer.dart';

abstract class CheckAnswersRepo {
  Future<Either<Failure, List<NeedReviewSolutionsEntity>>>
      fetchNeedReviewSolutions({List<String> solutionsNeedingReview});
  Future<Either<Failure, List<ProblemsEntity>>> fetchProblems(
      {List<int> solutionsNeedingReview});
  void addSolutionToProblem(String solution, int problemId);
  void updateCourse(String courseId, String solvedProblemId);
  Future<Either<Failure, bool>> updateAnswers(
      String solvedProblemid, List<Answer> answers);
}
