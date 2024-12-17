import 'package:bloc/bloc.dart';
import 'package:education_app/features/authentication/data/repos/auth_repo.dart';
import 'package:flutter/foundation.dart';

part 'teacher_subjects_state.dart';

class TeacherSubjectsCubit extends Cubit<TeacherSubjectsState> {
  AuthRepository authRepository;
  TeacherSubjectsCubit(this.authRepository) : super(TeacherCoursesInitial());
}
