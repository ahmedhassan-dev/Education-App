import 'package:education_app/data/models/problems.dart';
import 'package:education_app/data/services/firestore_services.dart';

class TeacherRepository {
  FirestoreServices firestoreServices;
  TeacherRepository(this.firestoreServices);

  Future<dynamic> retrieveTeacherData(
      {required String path, required String docName}) async {
    final teacher = await firestoreServices.retrieveDataFormDocument(
        path: path, docName: docName) as dynamic;
    return teacher;
  }

  Future<dynamic> retrieveLastProblemId(
      {required String path, required String docName}) async {
    final lastProblemId = await firestoreServices.retrieveDataFormDocument(
        path: path, docName: docName) as dynamic;
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

  Future<void> updateProblemsCount(
          {required String path, required Map<String, dynamic> data}) async =>
      await firestoreServices.updateData(
        path: path,
        data: data,
      );

  Future<void> storeNewProblem(
          {required String path, required Problems data}) async =>
      await firestoreServices.setData(
        path: path,
        data: data.toMap(),
      );
}
