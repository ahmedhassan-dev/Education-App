import 'package:bloc/bloc.dart';
import 'package:education_app/core/functions/service_locator.dart';
import 'package:education_app/features/authentication/data/repos/auth_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'teacher_subjects_state.dart';

class TeacherSubjectsCubit extends Cubit<TeacherSubjectsState> {
  AuthRepository authRepository;
  TeacherSubjectsCubit(this.authRepository) : super(TeacherCoursesInitial());

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
