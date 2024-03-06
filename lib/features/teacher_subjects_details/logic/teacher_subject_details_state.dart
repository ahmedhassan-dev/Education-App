part of 'teacher_subject_details_cubit.dart';

@immutable
sealed class TeacherSubjectDetailsState {}

final class TeacherSubjectDetailsInitial extends TeacherSubjectDetailsState {}

class ErrorOccurred extends TeacherSubjectDetailsState {
  final String errorMsg;

  ErrorOccurred({required this.errorMsg});
}

class CoursesLoaded extends TeacherSubjectDetailsState {
  final List<Courses> courses;

  CoursesLoaded(this.courses);
}
