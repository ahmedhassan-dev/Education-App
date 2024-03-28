import 'package:bloc/bloc.dart';
import 'package:education_app/core/functions/service_locator.dart';
import 'package:education_app/features/authentication/data/repos/auth_repo.dart';
import 'package:education_app/features/courses/data/models/courses.dart';
import 'package:education_app/features/courses/data/repos/courses_repo.dart';
import 'package:education_app/core/constants/api_path.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  List<Courses> courses = [];
  CoursesRepository coursesRepository;
  AuthRepository authRepository;
  CoursesCubit(this.coursesRepository, this.authRepository)
      : super(CoursesInitial());

  Future<List<Courses>> getAllCourses() async {
    await coursesRepository
        .getAllCourses(path: ApiPath.courses())
        .then((courses) {
      emit(CoursesLoaded(courses));
      this.courses = courses;
    });
    return courses;
  }

  Future<void> logOut() async {
    try {
      await authRepository.logout();
      await _removeSharedPreferencesData();
      emit(LogedOut());
    } catch (e) {
      if (!isClosed) {
        emit(LogedOutError(errorMsg: e.toString()));
      }
    }
  }

  Future<void> _removeSharedPreferencesData() async {
    final bool result = await getIt<SharedPreferences>().clear();
    debugPrint("Clearing SharedPreferences Data: ${result.toString()}");
  }
}
