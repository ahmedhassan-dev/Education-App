import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/features/teacher/check_answers/data/data_sources/check_answers_remote_data_source.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/repos/check_answers_repo.dart';

class CheckAnswersRepoImpl extends CheckAnswersRepo {
  final CheckAnswersRemoteDataSource checkAnswersRemoteDataSource;

  CheckAnswersRepoImpl({required this.checkAnswersRemoteDataSource});

  @override
  Future<Either<Failure, List<ProblemsEntity>>> fetchProblems(
      {List<String> needReviewSolutionsList = const []}) async {
    List<ProblemsEntity> problemsList;
    try {
      problemsList = await checkAnswersRemoteDataSource.fetchProblems(
          needReviewSolutionsList: needReviewSolutionsList);
      return right(problemsList);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NeedReviewSolutionsEntity>>>
      fetchNeedReviewSolutions(
          {List<String> needReviewSolutionsList = const []}) async {
    List<NeedReviewSolutionsEntity> solvedProblemsList;
    try {
      solvedProblemsList =
          await checkAnswersRemoteDataSource.fetchNeedReviewSolutions(
              needReviewSolutionsList: needReviewSolutionsList);
      return right(solvedProblemsList);
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
