import 'package:dartz/dartz.dart';
import 'package:education_app/core/errors/failure.dart';
import 'package:education_app/core/use_cases/use_case.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/repos/check_answers_repo.dart';

class FetchProblemsUseCase extends UseCase<List<ProblemsEntity>, NoParam> {
  final CheckAnswersRepo checkAnswersRepo;

  FetchProblemsUseCase(this.checkAnswersRepo);

  @override
  Future<Either<Failure, List<ProblemsEntity>>> call([NoParam? param]) async {
    return await checkAnswersRepo.fetchProblems();
  }
}
