import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/constants/api_path.dart';
import 'package:education_app/core/services/firestore_services.dart';
import 'package:education_app/features/problems/data/models/solved_problems.dart';
import 'package:education_app/features/problems/data/models/problems.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';

abstract class CheckAnswersRemoteDataSource {
  Future<List<ProblemsEntity>> fetchProblems(
      {required List<int> solutionsNeedingReview});
  Future<List<NeedReviewSolutionsEntity>> fetchNeedReviewSolutions(
      {required List<String> solutionsNeedingReview});
  void addSolutionToProblem(String solution, int problemId);
  void updateCourse(String path, String solvedProblemId);
  Future updateAnswers(String path, List<Map<String, dynamic>> answers);
}

class CheckAnswersRemoteDataSourceImpl extends CheckAnswersRemoteDataSource {
  FirestoreServices firestoreServices;
  CheckAnswersRemoteDataSourceImpl(this.firestoreServices);

  @override
  Future<List<ProblemsEntity>> fetchProblems(
      {required List<int> solutionsNeedingReview}) async {
    final problems = await firestoreServices.retrieveData(
        path: ApiPath.problems(),
        queryBuilder: (query) =>
            query.where("id", whereIn: solutionsNeedingReview)) as List;
    return problems
        .map((docSnapshot) => Problems.fromJson(docSnapshot.data()!))
        .toList();
  }

  @override
  Future<List<NeedReviewSolutionsEntity>> fetchNeedReviewSolutions(
      {required List<String> solutionsNeedingReview}) async {
    final solvedProblems = await firestoreServices.retrieveData(
        path: ApiPath.solvedProblemsCollection(),
        queryBuilder: (query) =>
            query.where("id", whereIn: solutionsNeedingReview)) as List;
    return solvedProblems
        .map((docSnapshot) => SolvedProblems.fromJson(docSnapshot.data()!))
        .toList();
  }

  @override
  void addSolutionToProblem(String solution, int problemId) {
    firestoreServices
        .updateData(path: ApiPath.storingProblem(problemId), data: {
      "solutions": FieldValue.arrayUnion([solution])
    });
  }

  @override
  void updateCourse(String path, String solvedProblemId) {
    decrementNeedReviewCounter(path: path);
    removeSolvedProblemIdFromSolutionsNeedingReview(
        path: path, solvedProblemId: solvedProblemId);
  }

  Future<void> decrementNeedReviewCounter({
    required String path,
  }) async =>
      await firestoreServices.updateData(
        path: path,
        data: {"needReviewCounter": FieldValue.increment(-1)},
      );

  Future<void> removeSolvedProblemIdFromSolutionsNeedingReview({
    required String path,
    required String solvedProblemId,
  }) async =>
      await firestoreServices.updateData(
        path: path,
        data: {
          "solutionsNeedingReview": FieldValue.arrayRemove([solvedProblemId])
        },
      );

  @override
  Future updateAnswers(String path, List<Map<String, dynamic>> answers) async =>
      await firestoreServices.updateData(
          path: path, data: {"answers": answers, "needReview": false});
}
