import 'package:education_app/core/services/firestore_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/authentication/data/repos/auth_repo.dart';
import '../../features/courses/data/repos/courses_repo.dart';
import '../../features/teacher/check_answers/data/data_sources/check_answers_remote_data_source.dart';
import '../../features/teacher/check_answers/data/repos/check_answers_repo_impl.dart';
import '../../features/teacher/courses_student_feedback/data/repos/courses_student_feedback_repo.dart';
import '../../features/teacher/courses_student_feedback/logic/courses_student_feedback_cubit.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<FirebaseMessaging>(FirebaseMessaging.instance);
  getIt.registerSingleton<FirestoreServices>(FirestoreServices());
  getIt.registerLazySingleton<CoursesStudentFeedbackCubit>(() =>
      CoursesStudentFeedbackCubit(
          CoursesStudentFeedbackRepository(getIt<FirestoreServices>())));
  getIt.registerLazySingleton<CheckAnswersRepoImpl>(() => CheckAnswersRepoImpl(
      checkAnswersRemoteDataSource: getIt<CheckAnswersRemoteDataSource>()));
  getIt.registerLazySingleton<CheckAnswersRemoteDataSource>(
      () => CheckAnswersRemoteDataSourceImpl(getIt<FirestoreServices>()));
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(getIt<FirestoreServices>()));
  getIt.registerLazySingleton<CoursesRepository>(
      () => CoursesRepository(getIt<FirestoreServices>()));
}
