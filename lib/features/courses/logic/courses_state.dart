part of 'courses_cubit.dart';

sealed class CoursesState {}

final class CoursesInitial extends CoursesState {}

final class LogedOut extends CoursesState {}

final class LogedOutError extends CoursesState {
  final String errorMsg;

  LogedOutError({required this.errorMsg});
}

class CoursesLoaded extends CoursesState {
  final List<Courses> courses;

  CoursesLoaded(this.courses);
}
