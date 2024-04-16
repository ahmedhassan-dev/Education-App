import 'package:education_app/core/constants/api_path.dart';
import 'package:education_app/core/services/firestore_services.dart';
import 'package:education_app/features/problems/data/models/solved_problems.dart';
import 'package:education_app/features/problems/data/models/problems.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';

abstract class CheckAnswersRemoteDataSource {
  Future<List<ProblemsEntity>> fetchProblems({required String courseId});
  Future<List<NeedReviewSolutionsEntity>> fetchNeedReviewSolutions(
      {required String courseId});
}

class CheckAnswersRemoteDataSourceImpl extends CheckAnswersRemoteDataSource {
  FirestoreServices firestoreServices;
  CheckAnswersRemoteDataSourceImpl(this.firestoreServices);

  @override
  Future<List<ProblemsEntity>> fetchProblems({required String courseId}) async {
    final problems = await firestoreServices.retrieveData(
        path: ApiPath.problems(),
        queryBuilder: (query) =>
            query.where("courseId", isEqualTo: courseId)) as List;
    return problems
        .map((docSnapshot) => Problems.fromJson(docSnapshot.data()!))
        .toList();
  }

  @override
  Future<List<NeedReviewSolutionsEntity>> fetchNeedReviewSolutions(
      {required String courseId}) async {
    final solvedProblems = await firestoreServices.retrieveData(
        path: ApiPath.problems(),
        queryBuilder: (query) => query
            .where("courseId", isEqualTo: "courseId")
            .where("needReview", isEqualTo: true)) as List;
    return solvedProblems
        .map((docSnapshot) => SolvedProblems.fromJson(docSnapshot.data()!))
        .toList();
  }
}
