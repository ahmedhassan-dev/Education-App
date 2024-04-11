import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';

abstract class CheckAnswersRepo {
  Future<List<SolvedProblemsEntity>> fetchSolvedProblems();
  Future<List<ProblemsEntity>> fetchProblems();
}
