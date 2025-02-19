import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/core/services/firestore_services.dart';

import '../../../../core/constants/api_path.dart';

class CoursesRepository {
  FirestoreServices firestoreServices;
  CoursesRepository(this.firestoreServices);
  Future<List<Courses>> getAllCourses() async {
    final courses = await firestoreServices.retrieveData(
      path: ApiPath.courses(),
      queryBuilder: (query) => query.where("accessType", isEqualTo: "public"),
    ) as List;
    return courses
        .map((docSnapshot) => Courses.fromJson(docSnapshot.data()!))
        .toList();
  }

  Future<void> incrementProblemsCount(String courseId) async {
    await firestoreServices.updateData(
      path: ApiPath.courses(courseId),
      data: {"problemsCount": FieldValue.increment(1)},
    );
  }

  Future<dynamic> retrieveLastProblemId(String courseId) async {
    final lastProblemId = await firestoreServices.retrieveDataFormDocument(
        path: ApiPath.courses(), docName: courseId) as dynamic;
    return lastProblemId;
  }
}
