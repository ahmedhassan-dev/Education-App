part of 'teacher_subjects_cubit.dart';

@immutable
sealed class TeacherSubjectsState {}

final class TeacherCoursesInitial extends TeacherSubjectsState {}

final class LogedOut extends TeacherSubjectsState {}

final class LogedOutError extends TeacherSubjectsState {
  final String errorMsg;

  LogedOutError({required this.errorMsg});
}
