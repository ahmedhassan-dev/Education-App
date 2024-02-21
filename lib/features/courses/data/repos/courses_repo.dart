import 'package:education_app/features/courses/data/models/courses_model.dart';
import 'package:education_app/core/services/firestore_services.dart';

class CoursesRepository {
  FirestoreServices firestoreServices;
  CoursesRepository(this.firestoreServices);
  Future<List<CoursesModel>> getAllCourses({required String path}) async {
    final courses = await firestoreServices.retrieveData(path: path) as List;
    return courses
        .map((docSnapshot) => CoursesModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
