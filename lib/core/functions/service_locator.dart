import 'package:education_app/core/services/firestore_services.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/teacher/courses_student_feedback/data/repos/courses_student_feedback_repo.dart';
import '../../features/teacher/courses_student_feedback/logic/courses_student_feedback_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<FirestoreServices>(FirestoreServices());
  getIt.registerLazySingleton<CoursesStudentFeedbackCubit>(() =>
      CoursesStudentFeedbackCubit(
          CoursesStudentFeedbackRepository(getIt<FirestoreServices>())));
}
