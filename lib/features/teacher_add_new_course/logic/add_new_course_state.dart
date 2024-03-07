part of 'add_new_course_cubit.dart';

@immutable
sealed class AddNewCourseState {}

final class AddNewCourseInitial extends AddNewCourseState {}

class Loading extends AddNewCourseState {}

class TeacherDataLoaded extends AddNewCourseState {}

class CourseDataStored extends AddNewCourseState {}

class ErrorOccurred extends AddNewCourseState {
  final String errorMsg;

  ErrorOccurred({required this.errorMsg});
}
