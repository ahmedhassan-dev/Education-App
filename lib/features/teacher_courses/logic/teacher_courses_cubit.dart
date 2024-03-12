import 'package:bloc/bloc.dart';
import 'package:education_app/features/authentication/data/repos/auth_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'teacher_courses_state.dart';

class TeacherCoursesCubit extends Cubit<TeacherCoursesState> {
  AuthRepository authRepository;
  TeacherCoursesCubit(this.authRepository) : super(TeacherCoursesInitial());

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool result = await prefs.clear();
    debugPrint("Clearing SharedPreferences Data: ${result.toString()}");
  }
}
