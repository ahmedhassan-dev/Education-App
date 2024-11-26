import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/repos/check_answers_repo.dart';

class FetchSolvedProblemsUseCase {
  final CheckAnswersRepo checkAnswersRepo;

  FetchSolvedProblemsUseCase(this.checkAnswersRepo);

  Future<Either<Failure, List<NeedReviewSolutionsEntity>>> call(
      List<String> param) async {
    return await checkAnswersRepo.fetchNeedReviewSolutions(
        solutionsNeedingReview: param);
  }
}
