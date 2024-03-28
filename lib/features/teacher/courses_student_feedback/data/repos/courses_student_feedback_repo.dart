import 'package:education_app/core/constants/api_path.dart';
import 'package:education_app/core/services/firestore_services.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoursesStudentFeedbackRepository {
  FirestoreServices firestoreServices;
  CoursesStudentFeedbackRepository(this.firestoreServices);

  Future<List<Courses>> getTeacherSortedCourses() async {
    final courses = await firestoreServices.retrieveData(
      path: ApiPath.courses(),
      queryBuilder: (query) => query
          .where("authorEmail",
              isEqualTo: _getTeacherEmailFromSharedPreferences)
          .orderBy("needReviewCounter"),
    ) as List;
    return courses
        .map((docSnapshot) => Courses.fromJson(docSnapshot.data()!))
        .toList();
  }

  Future<String> _getTeacherEmailFromSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email')!;
  }
}
