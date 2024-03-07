import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/core/services/firestore_services.dart';

class SubjectCoursesRepository {
  FirestoreServices firestoreServices;
  SubjectCoursesRepository(this.firestoreServices);
  Future<List<Courses>> getSubjectCourses(
      {required String path,
      required String subject,
      required String authorEmail}) async {
    final courses = await firestoreServices.retrieveSubjectCoursesData(
        path: path, subject: subject, authorEmail: authorEmail) as List;
    return courses
        .map((docSnapshot) => Courses.fromJson(docSnapshot.data()!))
        .toList();
  }
}
