import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/core/services/firestore_services.dart';

class CoursesRepository {
  FirestoreServices firestoreServices;
  CoursesRepository(this.firestoreServices);
  Future<List<Courses>> getAllCourses({required String path}) async {
    final courses = await firestoreServices.retrieveData(path: path) as List;
    return courses
        .map((docSnapshot) => Courses.fromJson(docSnapshot.data()!))
        .toList();
  }
}
