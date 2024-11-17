import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/constants/api_path.dart';
import 'package:education_app/core/services/firestore_services.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/problems/data/models/solved_problems.dart';
import 'package:education_app/features/problems/data/models/problems.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/problems_entity.dart';
import 'package:education_app/features/teacher/check_answers/domain/entities/solved_problems_entity.dart';

abstract class CheckAnswersRemoteDataSource {
  Future<List<ProblemsEntity>> fetchProblems(
      {required List<String> solutionsNeedingReview});
  Future<List<NeedReviewSolutionsEntity>> fetchNeedReviewSolutions(
      {required List<String> solutionsNeedingReview});
  void addSolutionToProblem(String solution, String problemId);
  void updateCourse(Courses course);
}

class CheckAnswersRemoteDataSourceImpl extends CheckAnswersRemoteDataSource {
  FirestoreServices firestoreServices;
  CheckAnswersRemoteDataSourceImpl(this.firestoreServices);

  @override
  Future<List<ProblemsEntity>> fetchProblems(
      {required List<String> solutionsNeedingReview}) async {
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
  void addSolutionToProblem(String solution, String problemId) {
    firestoreServices
        .updateData(path: ApiPath.storingProblem(problemId), data: {
      "solutions": FieldValue.arrayUnion([solution])
    });
  }

  @override
  void updateCourse(Courses course) {
    firestoreServices.updateData(
        path: ApiPath.coursesID(course.id!), data: course.toJson());
  }
}
