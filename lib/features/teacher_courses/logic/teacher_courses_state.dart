part of 'teacher_courses_cubit.dart';

@immutable
sealed class TeacherCoursesState {}

final class TeacherCoursesInitial extends TeacherCoursesState {}

final class LogedOut extends TeacherCoursesState {}

final class LogedOutError extends TeacherCoursesState {
  final String errorMsg;

  LogedOutError({required this.errorMsg});
}
