import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/repos/check_answers_repo.dart';

class FetchProblemsUseCase {
  final CheckAnswersRepo checkAnswersRepo;

  FetchProblemsUseCase(this.checkAnswersRepo);

  Future<Either<Failure, List<ProblemsEntity>>> call(List<int> param) async {
    return await checkAnswersRepo.fetchProblems(solutionsNeedingReview: param);
  }
}
