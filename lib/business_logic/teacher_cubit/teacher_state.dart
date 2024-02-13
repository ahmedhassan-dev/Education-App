part of 'teacher_cubit.dart';

@immutable
sealed class TeacherState {}

final class TeacherInitial extends TeacherState {}

class Loading extends TeacherState {}

class SubjectAdded extends TeacherState {}

class SubjectDelete extends TeacherState {}

class TeacherDataLoaded extends TeacherState {
  // final List<CoursesModel> courses;

  // CoursesLoaded();
}
