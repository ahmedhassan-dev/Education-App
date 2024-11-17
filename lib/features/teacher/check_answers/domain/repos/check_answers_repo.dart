import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';
import 'package:dartz/dartz.dart';

abstract class CheckAnswersRepo {
  Future<Either<Failure, List<NeedReviewSolutionsEntity>>>
      fetchNeedReviewSolutions({List<String> solutionsNeedingReview});
  Future<Either<Failure, List<ProblemsEntity>>> fetchProblems(
      {List<String> solutionsNeedingReview});
  void addSolutionToProblem(String solution, String problemId);
  void updateCourse(Courses course);
}
