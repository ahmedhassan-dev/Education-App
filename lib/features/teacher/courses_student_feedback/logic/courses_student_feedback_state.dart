part of 'courses_student_feedback_cubit.dart';

@immutable
sealed class CoursesStudentFeedbackState {}

final class CoursesStudentFeedbackInitial extends CoursesStudentFeedbackState {}

final class CoursesLoaded extends CoursesStudentFeedbackState {
  final List<Courses> courses;

  CoursesLoaded({required this.courses});
}

final class ErrorOccurred extends CoursesStudentFeedbackState {
  final String errorMsg;

  ErrorOccurred({required this.errorMsg});
}
