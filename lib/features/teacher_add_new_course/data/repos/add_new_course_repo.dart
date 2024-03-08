import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/core/services/firestore_services.dart';

class AddNewCourseRepository {
  FirestoreServices firestoreServices;
  AddNewCourseRepository(this.firestoreServices);

  Future<void> storeNewCourse(
          {required String path, required Courses data}) async =>
      await firestoreServices.setData(
        path: path,
        data: data.toJson(),
      );
}
