import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/use_cases/use_case.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/repos/check_answers_repo.dart';

class FetchSolvedProblemsUseCase
    extends UseCase<List<NeedReviewSolutionsEntity>, List<String>> {
  final CheckAnswersRepo checkAnswersRepo;

  FetchSolvedProblemsUseCase(this.checkAnswersRepo);

  @override
  Future<Either<Failure, List<NeedReviewSolutionsEntity>>> call(
      [List<String> param = const []]) async {
    //TODO: here is the problem and I have to check that the list is not empty cos It gives me an error
    return await checkAnswersRepo.fetchNeedReviewSolutions(
        needReviewSolutionsList: param);
  }
}
