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

  Future<void> updateTeacherData(
          {required String path, required Map<String, dynamic> data}) async =>
      await firestoreServices.updateData(
        path: path,
        data: data,
      );
}