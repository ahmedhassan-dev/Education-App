import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/features/problems/data/models/answer.dart';
import 'package:education_app/features/teacher/check_answers/data/data_sources/check_answers_remote_data_source.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/repos/check_answers_repo.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/constants/api_path.dart';

class CheckAnswersRepoImpl extends CheckAnswersRepo {
  final CheckAnswersRemoteDataSource checkAnswersRemoteDataSource;

  CheckAnswersRepoImpl({required this.checkAnswersRemoteDataSource});

  @override
  Future<Either<Failure, List<ProblemsEntity>>> fetchProblems(
      {List<int> solutionsNeedingReview = const []}) async {
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
  void addSolutionToProblem(String solution, int problemId) {
    try {
      checkAnswersRemoteDataSource.addSolutionToProblem(solution, problemId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void updateCourse(String courseId, String solvedProblemId) {
    try {
      checkAnswersRemoteDataSource.updateCourse(
          ApiPath.coursesID(courseId), solvedProblemId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<Either<Failure, bool>> updateAnswers(
      String solvedProblemid, List<Answer> answers, String nextRepeat) async {
    try {
      checkAnswersRemoteDataSource.updateAnswers(
          ApiPath.solvedProblems(solvedProblemid),
          answers.map((answer) => answer.toJson()).toList(),
          nextRepeat);
      return right(true);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
