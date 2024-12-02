import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/features/problems/data/models/problems.dart';
import 'package:education_app/core/services/firestore_services.dart';

import '../../../../../core/constants/api_path.dart';

class AddNewProblemRepository {
  FirestoreServices firestoreServices;
  AddNewProblemRepository(this.firestoreServices);

  Future<dynamic> retrieveTeacherData(
      {required String path, required String docName}) async {
    final teacher = await firestoreServices.retrieveDataFormDocument(
        path: path, docName: docName) as dynamic;
    return teacher;
  }

  Future<dynamic> retrieveLastProblemId({required String docName}) async {
    final lastProblemId = await firestoreServices.retrieveDataFormDocument(
        path: ApiPath.problemsCount(), docName: docName) as dynamic;
    return lastProblemId;
  }

  Future<dynamic> getLatestAppVersion(
      {required String path, required String docName}) async {
    final latestAppVersion = await firestoreServices.retrieveDataFormDocument(
        path: path, docName: docName) as dynamic;
    return latestAppVersion;
  }

  Future<void> updateTeacherData(
          {required String path, required Map<String, dynamic> data}) async =>
      await firestoreServices.updateData(
        path: path,
        data: data,
      );

  Future<void> incrementProblemsCount() async {
    await firestoreServices.updateData(
      path: ApiPath.problemsCount(),
      data: {"problemsCount": FieldValue.increment(1)},
    );
  }

  Future<void> storeNewProblem(
          {required String path, required Problems data}) async =>
      await firestoreServices.setData(
        path: path,
        data: data.toJson(),
      );

  Future<List<Problems>> retrieveCourseProblems(
      {required String path,
      required String courseId,
      required String sortedBy}) async {
    final problems = await firestoreServices.retrieveData(
        path: path,
        queryBuilder: (query) => query
            .where("courseId", isEqualTo: courseId)
            .orderBy(sortedBy, descending: true)) as List;
    return problems
        .map((docSnapshot) => Problems.fromJson(docSnapshot.data()!))
        .toList();
  }
}
