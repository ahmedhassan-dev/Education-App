import 'package:education_app/core/constants/api_path.dart';
import 'package:education_app/core/services/firestore_services.dart';
import 'package:education_app/features/problems/data/models/solved_problems.dart';
import 'package:education_app/features/problems/data/models/problems.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';

abstract class CheckAnswersRemoteDataSource {
  Future<List<ProblemsEntity>> fetchProblems(
      {required List<String> needReviewSolutionsList});
  Future<List<NeedReviewSolutionsEntity>> fetchNeedReviewSolutions(
      {required List<String> needReviewSolutionsList});
}

class CheckAnswersRemoteDataSourceImpl extends CheckAnswersRemoteDataSource {
  FirestoreServices firestoreServices;
  CheckAnswersRemoteDataSourceImpl(this.firestoreServices);

  @override
  Future<List<ProblemsEntity>> fetchProblems(
      {required List<String> needReviewSolutionsList}) async {
    final problems = await firestoreServices.retrieveData(
            path: ApiPath.problems(),
            queryBuilder: (query) =>
                query.where("id", arrayContainsAny: needReviewSolutionsList))
        as List;
    return problems
        .map((docSnapshot) => Problems.fromJson(docSnapshot.data()!))
        .toList();
  }

  @override
  Future<List<NeedReviewSolutionsEntity>> fetchNeedReviewSolutions(
      {required List<String> needReviewSolutionsList}) async {
    final solvedProblems = await firestoreServices.retrieveData(
            path: ApiPath.problems(),
            queryBuilder: (query) =>
                query.where("id", arrayContainsAny: needReviewSolutionsList))
        as List;
    print("solvedProblems:              $solvedProblems");
    return solvedProblems
        .map((docSnapshot) => SolvedProblems.fromJson(docSnapshot.data()!))
        .toList();
  }
}
