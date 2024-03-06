import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/core/services/firestore_services.dart';

class SubjectCoursesRepository {
  FirestoreServices firestoreServices;
  SubjectCoursesRepository(this.firestoreServices);
  Future<List<Courses>> getSubjectCourses(
      {required String path,
      required String subject,
      required String author}) async {
    final courses = await firestoreServices.retrieveSubjectCoursesData(
        path: path, subject: subject, author: author) as List;
    return courses
        .map((docSnapshot) => Courses.fromJson(docSnapshot.data()!))
        .toList();
  }
}
