import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/features/authentication/data/models/student.dart';
import 'package:education_app/features/problems/data/models/problems.dart';
import 'package:education_app/features/problems/data/models/solved_problems.dart';
import 'package:education_app/core/services/firestore_services.dart';

class ProblemsRepository {
  FirestoreServices firestoreServices;
  ProblemsRepository(this.firestoreServices);

  Future<Student> retrieveUserData(
      {required String path, required String docName}) async {
    dynamic userData = await firestoreServices.retrieveDataFormDocument(
        path: path, docName: docName);
    return Student.fromJson(userData.data()!);
  }

  Future<void> updatingStudentData({
    required String path,
    required Map<String, dynamic> data,
  }) async =>
      await firestoreServices.updateData(
        path: path,
        data: data,
      );

  Future<void> incrementNeedReviewCounter({
    required String path,
  }) async =>
      await firestoreServices.updateData(
        path: path,
        data: {"needReviewCounter": FieldValue.increment(1)},
      );

  Future<List<Problems>> retrieveCourseProblems(
      {required String path,
      required String courseId,
      required String sortedBy}) async {
    final courseProblems = await firestoreServices.retrieveData(
            path: path,
            queryBuilder: (query) =>
                query.where("courseId", isEqualTo: courseId).orderBy(sortedBy))
        as List;
    return courseProblems
        .map((docSnapshot) => Problems.fromJson(docSnapshot.data()!))
        .toList();
  }

  Future<List<SolvedProblems>> retrieveSolvedProblems(
      {required String path,
      required String courseId,
      required String sortedBy}) async {
    final courseProblems = await firestoreServices.retrieveData(
            path: path,
            queryBuilder: (query) =>
                query.where("courseId", isEqualTo: courseId).orderBy(sortedBy))
        as List;
    return courseProblems
        .map((docSnapshot) => SolvedProblems.fromJson(docSnapshot.data()!))
        .toList();
  }

  Future<void> submitSolution(
          {required SolvedProblems solution, required String path}) =>
      firestoreServices.setData(
        path: path,
        data: solution.toJson(),
      );
}
