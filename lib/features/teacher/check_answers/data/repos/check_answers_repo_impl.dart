import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/teacher/check_answers/data/data_sources/check_answers_remote_data_source.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/repos/check_answers_repo.dart';
import 'package:flutter/foundation.dart';

class CheckAnswersRepoImpl extends CheckAnswersRepo {
  final CheckAnswersRemoteDataSource checkAnswersRemoteDataSource;

  CheckAnswersRepoImpl({required this.checkAnswersRemoteDataSource});

  @override
  Future<Either<Failure, List<ProblemsEntity>>> fetchProblems(
      {List<String> solutionsNeedingReview = const []}) async {
    List<ProblemsEntity> problemsList;
    try {
      problemsList = await checkAnswersRemoteDataSource.fetchProblems(
          solutionsNeedingReview: solutionsNeedingReview);
      return right(problemsList);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NeedReviewSolutionsEntity>>>
      fetchNeedReviewSolutions(
          {List<String> solutionsNeedingReview = const []}) async {
    List<NeedReviewSolutionsEntity> solvedProblemsList;
    try {
      solvedProblemsList =
          await checkAnswersRemoteDataSource.fetchNeedReviewSolutions(
              solutionsNeedingReview: solutionsNeedingReview);
      return right(solvedProblemsList);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  void addSolutionToProblem(String solution, String problemId) {
    try {
      checkAnswersRemoteDataSource.addSolutionToProblem(solution, problemId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void updateCourse(Courses course) {
    try {
      checkAnswersRemoteDataSource.updateCourse(course);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
